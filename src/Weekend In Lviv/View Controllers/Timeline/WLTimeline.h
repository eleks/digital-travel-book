//
//  WLTimeline.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/25/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLTimelineImageView.h"



@interface WLTimeline : UIViewController <UIScrollViewDelegate, WLTimelineImageViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollTimeline;
@property (weak, nonatomic) IBOutlet UIView *viewCentury;
@property (weak, nonatomic) IBOutlet UIImageView *imgBottom;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UIView *viewTimelinePoints;

@property (weak, nonatomic) IBOutlet UIButton *btnFurstenhalter;
@property (weak, nonatomic) IBOutlet UIButton *btnExpansion;
@property (weak, nonatomic) IBOutlet UIButton *btnBefreiungskampf;
@property (weak, nonatomic) IBOutlet UIButton *btnNeueGeschitchte;


@property (weak, nonatomic) IBOutlet UIView *navigationView;
@end
