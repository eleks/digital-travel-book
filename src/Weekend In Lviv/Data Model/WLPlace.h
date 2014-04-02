//
//  WLPlace.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/18/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WLPlace : NSObject


@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *placeText;
@property (strong, nonatomic) NSString *placeTopImagePath;
@property (strong, nonatomic) NSString *placeMenuImagePath;
@property (strong, nonatomic) NSString *listImagePath;
@property (strong, nonatomic) NSArray *placesTextBlocks;
@property (strong, nonatomic) NSArray *placesPointBlocks;
@property (strong, nonatomic) NSString *placeAudioPath;
@property (nonatomic) BOOL placeFavourite;
@property (strong, nonatomic) NSNumber *moIdentificator;

@end
