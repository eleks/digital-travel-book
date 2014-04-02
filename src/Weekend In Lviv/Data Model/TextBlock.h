//
//  TextBlock.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/21/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Image, LocalizedText, Place;


@interface TextBlock : NSManagedObject


@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSSet *images;
@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) NSSet *subtitle;
@property (nonatomic, strong) NSSet *texts;
@property (nonatomic, strong) NSSet *titles;
@end


@interface TextBlock (CoreDataGeneratedAccessors)


- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addSubtitleObject:(LocalizedText *)value;
- (void)removeSubtitleObject:(LocalizedText *)value;
- (void)addSubtitle:(NSSet *)values;
- (void)removeSubtitle:(NSSet *)values;

- (void)addTextsObject:(LocalizedText *)value;
- (void)removeTextsObject:(LocalizedText *)value;
- (void)addTexts:(NSSet *)values;
- (void)removeTexts:(NSSet *)values;

- (void)addTitlesObject:(LocalizedText *)value;
- (void)removeTitlesObject:(LocalizedText *)value;
- (void)addTitles:(NSSet *)values;
- (void)removeTitles:(NSSet *)values;

@end
