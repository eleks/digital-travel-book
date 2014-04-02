//
//  WLPointVC.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/20/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WLPoint;


@interface WLPointVC : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *imgMain;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;


- (void)setDetailWithPoint:(WLPoint *)point;

@end
