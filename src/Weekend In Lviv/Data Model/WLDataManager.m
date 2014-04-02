//
//  WLDataManager.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/15/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLDataManager.h"
#import "WLAppDelegate.h"
#import "UIImage+Resize.h"
#import "Place.h"
#import "TextBlock.h"
#import "LocalizedText.h"
#import "Image.h"
#import "AudioFile.h"
#import "PointBlock.h"
#import "PointOfBlock.h"
#import "UIScreen+SSToolkitAdditions.h"
#import "WLPlace.h"
#import "WLTextBlock.h"
#import "WLPointBlock.h"
#import "WLPoint.h"


@implementation WLDataManager


static WLDataManager *sharedManager = nil;


+ (WLDataManager *)sharedManager {
    static dispatch_once_t predicate = 0;
    __strong static WLDataManager *sharedManager = nil;
    dispatch_once(&predicate, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.managedObjectContext = [(WLAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];

    return self;
}


- (void)fillPlacesList {
    NSArray *places = [self places];
    NSString *language = [NSLocale preferredLanguages][0];
    self.placesList = [NSMutableArray array];
    NSArray *sortByTimestamp = @[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]];
    for (Place *place in places) {
        WLPlace *newPlace = [[WLPlace alloc] init];
        newPlace.title = [self placeMainTitleWithLocale:language place:place];
        newPlace.placeTopImagePath = place.topImage.pathToFile;
        newPlace.listImagePath = place.listIcon.pathToFile;
        newPlace.placeMenuImagePath = place.menuIcon.pathToFile;
        newPlace.placeText = [self placeMainTextWithLocale:language place:place];
        newPlace.placeAudioPath = [self placeAudioWithLocale:language place:place];
        newPlace.moIdentificator = place.identificator;
        newPlace.placeFavourite = [place.favourite boolValue];
        NSArray *textBlocks = [[place.blocks allObjects] sortedArrayUsingDescriptors:sortByTimestamp];
        NSMutableArray *texts = [NSMutableArray array];
        for (TextBlock *block in textBlocks) {
            [texts addObject:[self placeTextBlockWithLocale:language textBlock:block]];
        }
        newPlace.placesTextBlocks = texts;

        NSArray *pointBlocks = [[place.pointBlocks allObjects] sortedArrayUsingDescriptors:sortByTimestamp];
        NSMutableArray *points = [NSMutableArray array];
        for (PointBlock *pointBlock in pointBlocks) {
            [points addObject:[self pointBlockWithLocale:language pointBlock:pointBlock]];
        }
        newPlace.placesPointBlocks = points;

        [self.placesList addObject:newPlace];
    }
}


- (void)clearPlacesData {
    NSArray *places = [self places];
    if ([places count] > 0) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.dataFolder]) {
            NSError *error = nil;
            BOOL result = [[NSFileManager defaultManager] removeItemAtPath:self.dataFolder error:&error];
            if (!result) {
                NSLog(@"Folder deleting error:%@ ", error.localizedDescription);
            }

        }

        for (Place *place in places) {
            [self.managedObjectContext deleteObject:place];
        }
        [self saveContext];
    }
}


- (NSString *)dataFolder {
    if (!_dataFolder) {
        NSString *documentPath = [(WLAppDelegate *) [[UIApplication sharedApplication] delegate] applicationDocumentsDirectory].path;
        _dataFolder = [documentPath stringByAppendingPathComponent:@".localData"];

    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:_dataFolder]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:_dataFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Local data document folder creation error :%@", error.localizedDescription);
        }
    }
    return _dataFolder;
}


- (BOOL)saveContext {
    NSError *error = nil;
    if (self.managedObjectContext != nil) {
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return NO;

        }
        return YES;
    }

    return NO;
}


- (Place *)addPlaceWithOptions:(NSDictionary *)options {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:self.managedObjectContext];
    Place *newPlace = [[Place alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    newPlace.topImage = [self addImageWithFileName:options[@"topImageName"]];
    newPlace.listIcon = [self addImageWithFileName:options[@"lictIconImageName"]];
    newPlace.menuIcon = [self addImageWithFileName:options[@"menuIconImageName"]];
    newPlace.identificator = @([NSDate timeIntervalSinceReferenceDate]);
    NSDictionary *titles = options[@"mainTitle"];
    for (NSString *key in titles.allKeys) {
        [newPlace addTitlesObject:[self addLocalizedTextWithLocale:key text:titles[key]]];
    }

    NSDictionary *texts = options[@"mainText"];
    for (NSString *key in texts.allKeys) {
        [newPlace addTextObject:[self addLocalizedTextWithLocale:key text:texts[key]]];
    }

    for (NSDictionary *textBlockDict in options[@"textBlocks"]) {
        [newPlace addBlocksObject:[self addTextBlockWithOptions:textBlockDict]];
    }

    for (NSDictionary *pointBlockDict in options[@"pointBlocks"]) {
        [newPlace addPointBlocksObject:[self addPointBlockWithOptions:pointBlockDict]];
    }

    NSDictionary *audios = options[@"audioFiles"];
    for (NSString *key in audios) {
        [newPlace addAudioFilesObject:[self addAudioFileWithLocale:key fileName:audios[key]]];
    }

    return newPlace;
}


- (Place *)placeWithIdentifier:(NSNumber *)identifier {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identificator == %@", identifier];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Place fetching error: %@", error.localizedDescription);
    }

    return [array lastObject];
}


- (Image *)addImageWithFileName:(NSString *)fileName {
    NSString *file = [fileName componentsSeparatedByString:@"."][0];
    NSString *type = [[fileName componentsSeparatedByString:@"."] lastObject];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *savedImage = nil;
    if (![[UIScreen mainScreen] isRetinaDisplay]) {
        CGSize newSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
        savedImage = [image resizeImage:newSize interpolationQuality:kCGInterpolationHigh];
    }
    else {
        savedImage = image;
    }


    NSString *filePath = [self.dataFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%f.jpeg", file, [NSDate timeIntervalSinceReferenceDate]]];
    NSData *savedImageData = UIImageJPEGRepresentation(savedImage, 0.5);
    [savedImageData writeToFile:filePath atomically:YES];


    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:self.managedObjectContext];
    Image *returnedImage = [[Image alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    returnedImage.pathToFile = filePath;
    returnedImage.timestamp = [NSDate date];

    return returnedImage;
}


- (UIImage *)imageWithPath:(NSString *)path {
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    return [UIImage imageWithData:imgData];
}


- (NSArray *)imageListWithPlace:(WLPlace *)place {
    NSMutableArray *result = [NSMutableArray array];

    for (WLTextBlock *textBlock in place.placesTextBlocks) {
        [result addObjectsFromArray:textBlock.blockImagesPath];
    }

    return result;
}


- (LocalizedText *)addLocalizedTextWithLocale:(NSString *)locale text:(NSString *)text {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"LocalizedText" inManagedObjectContext:self.managedObjectContext];
    LocalizedText *localizedText = [[LocalizedText alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    localizedText.locale = locale;
    localizedText.text = text;
    return localizedText;
}



- (NSString *)placeMainTitleWithLocale:(NSString *)locale place:(Place *)place {
    return [self getString:locale localizedStrings:place.titles];
}


- (NSString *)placeMainTextWithLocale:(NSString *)locale place:(Place *)place {
    return [self getString:locale localizedStrings:place.text];
}


- (NSString *)textBlockTitleWithLocale:(NSString *)locale textBlock:(TextBlock *)textBlock {
    return [self getString:locale localizedStrings:textBlock.titles];
}


- (NSString *)textBlockSubtitleWithLocale:(NSString *)locale textBlock:(TextBlock *)textBlock {
    return [self getString:locale localizedStrings:textBlock.subtitle];
}


- (NSString *)textBlockTextWithLocale:(NSString *)locale textBlock:(TextBlock *)textBlock {
    return [self getString:locale localizedStrings:textBlock.texts];
}


- (NSString *)pointBlockTextWithLocale:(NSString *)locale pointBlock:(PointBlock *)pointBlock {
    return [self getString:locale localizedStrings:pointBlock.mainText];
}


- (NSString *)pointTextWithLocale:(NSString *)locale point:(PointOfBlock *)point {
    return [self getString:locale localizedStrings:point.text];
}



- (NSString *)getString:(NSString *)locale localizedStrings:(NSSet *)localizedStrings {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locale == %@", locale];
    LocalizedText *title = [[localizedStrings filteredSetUsingPredicate:predicate] anyObject];

    if (!title) {
        predicate = [NSPredicate predicateWithFormat:@"locale == %@", @"de"];
        title = [[localizedStrings filteredSetUsingPredicate:predicate] anyObject];
    }

    return title.text;
}


- (TextBlock *)addTextBlockWithOptions:(NSDictionary *)options {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TextBlock" inManagedObjectContext:self.managedObjectContext];
    TextBlock *newTextBlock = [[TextBlock alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    newTextBlock.timestamp = [NSDate date];
    NSDictionary *titles = options[@"title"];
    for (NSString *key in titles.allKeys) {
        [newTextBlock addTitlesObject:[self addLocalizedTextWithLocale:key text:titles[key]]];
    }

    NSDictionary *subtitles = options[@"subtitle"];
    for (NSString *key in subtitles.allKeys) {
        [newTextBlock addSubtitleObject:[self addLocalizedTextWithLocale:key text:subtitles[key]]];
    }

    NSDictionary *texts = options[@"text"];
    for (NSString *key in texts.allKeys) {
        [newTextBlock addTextsObject:[self addLocalizedTextWithLocale:key text:texts[key]]];
    }

    for (NSString *imageNames in options[@"images"]) {
        NSLog(@"%@", imageNames);
        [newTextBlock addImagesObject:[self addImageWithFileName:imageNames]];
    }

    return newTextBlock;
}


- (WLTextBlock *)placeTextBlockWithLocale:(NSString *)locale textBlock:(TextBlock *)block {
    WLTextBlock *newTextBlock = [[WLTextBlock alloc] init];
    newTextBlock.blockTitle = [self textBlockTitleWithLocale:locale textBlock:block];
    newTextBlock.blockSubtitle = [self textBlockSubtitleWithLocale:locale textBlock:block];
    newTextBlock.blockText = [self textBlockTextWithLocale:locale textBlock:block];

    NSMutableArray *temporaryImages = [NSMutableArray array];
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];

    for (Image *image in [[block.images allObjects] sortedArrayUsingDescriptors:@[dateSortDescriptor]]) {
        [temporaryImages addObject:image.pathToFile];
    }
    newTextBlock.blockImagesPath = temporaryImages;

    return newTextBlock;
}


- (PointBlock *)addPointBlockWithOptions:(NSDictionary *)options {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PointBlock" inManagedObjectContext:self.managedObjectContext];
    PointBlock *pointBlock = [[PointBlock alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    pointBlock.image = [self addImageWithFileName:options[@"imageName"]];
    pointBlock.timestamp = [NSDate date];
    NSDictionary *texts = options[@"text"];
    for (NSString *key in texts.allKeys) {
        [pointBlock addMainTextObject:[self addLocalizedTextWithLocale:key text:texts[key]]];
    }

    for (NSDictionary *pointDict in options[@"points"]) {
        [pointBlock addPointsObject:[self addPointOfBlockWithOptions:pointDict]];
    }

    return pointBlock;

}


- (WLPointBlock *)pointBlockWithLocale:(NSString *)locale pointBlock:(PointBlock *)block {
    WLPointBlock *pointBlock = [[WLPointBlock alloc] init];
    pointBlock.blockImagePath = block.image.pathToFile;
    pointBlock.blockText = [self pointBlockTextWithLocale:locale pointBlock:block];
    NSMutableArray *points = [NSMutableArray array];
    for (PointOfBlock *point in block.points) {
        [points addObject:[self pointWithLocale:locale pointOfBlock:point]];
    }
    pointBlock.blockPoints = points;

    return pointBlock;
}


- (PointOfBlock *)addPointOfBlockWithOptions:(NSDictionary *)options {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PointOfBlock" inManagedObjectContext:self.managedObjectContext];
    PointOfBlock *pointOfBlock = [[PointOfBlock alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    pointOfBlock.image = [self addImageWithFileName:options[@"image"]];
    pointOfBlock.x = @([options[@"pointX"] integerValue]);
    pointOfBlock.y = @([options[@"pointY"] integerValue]);
    NSDictionary *texts = options[@"bottomText"];
    for (NSString *key in texts.allKeys) {
        [pointOfBlock addTextObject:[self addLocalizedTextWithLocale:key text:texts[key]]];
    }

    return pointOfBlock;
}


- (WLPoint *)pointWithLocale:(NSString *)locale pointOfBlock:(PointOfBlock *)pointOfBlock {
    WLPoint *point = [[WLPoint alloc] init];

    point.imagePath = pointOfBlock.image.pathToFile;
    point.x = [pointOfBlock.x floatValue];
    point.y = [pointOfBlock.y floatValue];
    point.text = [self pointTextWithLocale:locale point:pointOfBlock];

    return point;
}


- (AudioFile *)addAudioFileWithLocale:(NSString *)locale fileName:(NSString *)fileName {
    NSString *file = [[fileName lastPathComponent] stringByDeletingPathExtension];
    NSString *type = [fileName pathExtension];

    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:type];

    NSString *newFilePath = [self.dataFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%f.%@", file, [NSDate timeIntervalSinceReferenceDate], type]];

    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:newFilePath error:&error];
    if (error) {
        NSLog(@"Audio file copy error: %@", error.localizedDescription);
        return nil;
    }

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"AudioFile" inManagedObjectContext:self.managedObjectContext];

    AudioFile *audioFile = [[AudioFile alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    audioFile.path = newFilePath;
    audioFile.locale = locale;

    return audioFile;
}


- (NSString *)placeAudioWithLocale:(NSString *)locale place:(Place *)place {
    return [self getString:locale localizedStrings:place.audioFiles];
}


- (NSArray *)places {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    return [self.managedObjectContext executeFetchRequest:request error:nil];
}


@end
