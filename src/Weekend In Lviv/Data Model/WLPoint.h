//
//  WLPoint.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/20/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WLPoint : NSObject


@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *imagePath;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@end
