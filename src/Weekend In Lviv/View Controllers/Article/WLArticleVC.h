//
//  WLArticleVC.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/12/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLArticleBlock.h"

@class WLPlace;
@class WLAudioPlayerVC;


@interface WLArticleVC : UIViewController <UIPopoverControllerDelegate, WLDetailBlockDelegate>

@property (weak, nonatomic) WLPlace *place;
@property (nonatomic, weak) IBOutlet UIButton *btnAddToFavourites;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollDetail;
@property (nonatomic, weak) IBOutlet WLCoreTextLabel *lblFirst;
@property (nonatomic, weak) IBOutlet UIView *swipeLayer;
@property (nonatomic, weak) IBOutlet UILabel *lblSwipe;
@property (nonatomic, weak) IBOutlet UIImageView *imgTop;
@property (nonatomic, weak) IBOutlet UILabel *lblPlaceTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayAudio;


- (IBAction)btnPlayAudioTouch:(UIButton *)sender;
- (IBAction)btnBackwardTouch:(id)sender;
- (IBAction)btnForwardTouch:(id)sender;
- (IBAction)btnAddToFavouriteTouch:(id)sender;
- (void)scrollToTop;
@end
