//
//  PointOfBlock.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/21/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Image, LocalizedText, PointBlock;


@interface PointOfBlock : NSManagedObject


@property (nonatomic, strong) NSNumber *x;
@property (nonatomic, strong) NSNumber *y;
@property (nonatomic, strong) PointBlock *pointBlock;
@property (nonatomic, strong) Image *image;
@property (nonatomic, strong) NSSet *text;
@end


@interface PointOfBlock (CoreDataGeneratedAccessors)


- (void)addTextObject:(LocalizedText *)value;
- (void)removeTextObject:(LocalizedText *)value;
- (void)addText:(NSSet *)values;
- (void)removeText:(NSSet *)values;

@end
