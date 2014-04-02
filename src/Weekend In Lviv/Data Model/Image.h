//
//  Image.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/21/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Place, PointBlock, PointOfBlock, TextBlock;


@interface Image : NSManagedObject


@property (nonatomic, strong) NSString *pathToFile;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) TextBlock *textBlock;
@property (nonatomic, strong) PointBlock *pointBlock;
@property (nonatomic, strong) PointOfBlock *point;
@property (nonatomic, strong) Place *placeMenu;
@property (nonatomic, strong) Place *placeList;

@end
