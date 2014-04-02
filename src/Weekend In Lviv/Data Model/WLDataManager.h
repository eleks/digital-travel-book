//
//  WLDataManager.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/15/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//


@class Place;
@class Image;
@class LocalizedText;
@class WLPlace;
@class TextBlock;
@class PointBlock;
@class PointOfBlock;
@class WLTextBlock;
@class WLPointBlock;
@class WLPoint;
@class AudioFile;


@interface WLDataManager : NSObject {
    NSString *_dataFolder;
}


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSString *dataFolder;
@property (strong, nonatomic) NSMutableArray *placesList;

+ (WLDataManager *)sharedManager;

- (void)fillPlacesList;

- (void)clearPlacesData;
- (BOOL)saveContext;

- (Place *)addPlaceWithOptions:(NSDictionary *)options;
- (Place *)placeWithIdentifier:(NSNumber *)identifier;

- (Image *)addImageWithFileName:(NSString *)fileName;
- (UIImage *)imageWithPath:(NSString *)path;
- (NSArray *)imageListWithPlace:(WLPlace *)place;

- (LocalizedText *)addLocalizedTextWithLocale:(NSString *)locale text:(NSString *)text;
- (NSString *)placeMainTitleWithLocale:(NSString *)locale place:(Place *)place;
- (NSString *)placeMainTextWithLocale:(NSString *)locale place:(Place *)place;
- (NSString *)textBlockTitleWithLocale:(NSString *)locale textBlock:(TextBlock *)textBlock;
- (NSString *)textBlockSubtitleWithLocale:(NSString *)locale textBlock:(TextBlock *)textBlock;
- (NSString *)textBlockTextWithLocale:(NSString *)locale textBlock:(TextBlock *)textBlock;
- (NSString *)pointBlockTextWithLocale:(NSString *)locale pointBlock:(PointBlock *)pointBlock;
- (NSString *)pointTextWithLocale:(NSString *)locale point:(PointOfBlock *)point;

- (TextBlock *)addTextBlockWithOptions:(NSDictionary *)options;
- (WLTextBlock *)placeTextBlockWithLocale:(NSString *)locale textBlock:(TextBlock *)block;

- (PointBlock *)addPointBlockWithOptions:(NSDictionary *)options;
- (WLPointBlock *)pointBlockWithLocale:(NSString *)locale pointBlock:(PointBlock *)block;

- (PointOfBlock *)addPointOfBlockWithOptions:(NSDictionary *)options;
- (WLPoint *)pointWithLocale:(NSString *)locale pointOfBlock:(PointOfBlock *)pointOfBlock;

- (AudioFile *)addAudioFileWithLocale:(NSString *)locale fileName:(NSString *)fileName;
- (NSString *)placeAudioWithLocale:(NSString *)locale place:(Place *)place;

- (NSArray *)places;
@end
