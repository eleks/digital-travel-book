//
//  AudioFile.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/21/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Place;


@interface AudioFile : NSManagedObject


@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) Place *place;
@property (nonatomic, readonly) NSString *text;


@end
