//
//  WLHomeVC.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/11/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WLHomeVC : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *lblMainSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMainTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgMainTitle;
@property (weak, nonatomic) IBOutlet UIView *viewTimeLine;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollHome;

@property (weak, nonatomic) IBOutlet UIImageView *imgHeaderImage;

@property (weak, nonatomic) IBOutlet UIView *viewTimelineLeft;
@property (weak, nonatomic) IBOutlet UIView *viewTimelineRight;
@property (weak, nonatomic) IBOutlet UILabel *lblTimelineTop;
@property (weak, nonatomic) IBOutlet UILabel *lblTimelineTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTimelineSubtitle;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *yearPoints;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *yearPointsRight;
- (void)switchToViewControllerWithIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)popToRootAnimated:(BOOL)animated;
@end
