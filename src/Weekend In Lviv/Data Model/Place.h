//
//  Place.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/22/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class AudioFile, Image, LocalizedText, PointBlock, TextBlock;


@interface Place : NSManagedObject


@property (nonatomic, strong) NSNumber *favourite;
@property (nonatomic, strong) NSNumber *identificator;
@property (nonatomic, strong) NSSet *audioFiles;
@property (nonatomic, strong) NSSet *blocks;
@property (nonatomic, strong) Image *listIcon;
@property (nonatomic, strong) Image *menuIcon;
@property (nonatomic, strong) NSSet *pointBlocks;
@property (nonatomic, strong) NSSet *text;
@property (nonatomic, strong) NSSet *titles;
@property (nonatomic, strong) Image *topImage;
@end


@interface Place (CoreDataGeneratedAccessors)


- (void)addAudioFilesObject:(AudioFile *)value;
- (void)removeAudioFilesObject:(AudioFile *)value;
- (void)addAudioFiles:(NSSet *)values;
- (void)removeAudioFiles:(NSSet *)values;

- (void)addBlocksObject:(TextBlock *)value;
- (void)removeBlocksObject:(TextBlock *)value;
- (void)addBlocks:(NSSet *)values;
- (void)removeBlocks:(NSSet *)values;

- (void)addPointBlocksObject:(PointBlock *)value;
- (void)removePointBlocksObject:(PointBlock *)value;
- (void)addPointBlocks:(NSSet *)values;
- (void)removePointBlocks:(NSSet *)values;

- (void)addTextObject:(LocalizedText *)value;
- (void)removeTextObject:(LocalizedText *)value;
- (void)addText:(NSSet *)values;
- (void)removeText:(NSSet *)values;

- (void)addTitlesObject:(LocalizedText *)value;
- (void)removeTitlesObject:(LocalizedText *)value;
- (void)addTitles:(NSSet *)values;
- (void)removeTitles:(NSSet *)values;

@end
