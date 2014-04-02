//
//  PointBlock.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/21/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Image, LocalizedText, Place, PointOfBlock;


@interface PointBlock : NSManagedObject


@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) Image *image;
@property (nonatomic, strong) NSSet *mainText;
@property (nonatomic, strong) NSSet *points;
@property (nonatomic, strong) Place *place;
@end


@interface PointBlock (CoreDataGeneratedAccessors)


- (void)addMainTextObject:(LocalizedText *)value;
- (void)removeMainTextObject:(LocalizedText *)value;
- (void)addMainText:(NSSet *)values;
- (void)removeMainText:(NSSet *)values;

- (void)addPointsObject:(PointOfBlock *)value;
- (void)removePointsObject:(PointOfBlock *)value;
- (void)addPoints:(NSSet *)values;
- (void)removePoints:(NSSet *)values;

@end
