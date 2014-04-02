//
//  WLPointBlockView.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/20/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WLPointBlock;


@interface WLPointBlockView : UIView <UIPopoverControllerDelegate> {
    BOOL _pointShowing;

    UIImage *_imgBtnNormal;
    UIImage *_imgBtnHighlighted;
    UIImage *_imgBtnSelected;
}


@property (weak, nonatomic) IBOutlet UIImageView *imgMain;
@property (weak, nonatomic) IBOutlet UILabel *lblFirst;
@property (weak, nonatomic) IBOutlet UIView *textView;

- (void)setLayoutWithPointBlock:(WLPointBlock *)pointBlock;

- (void)dismissPopover;

- (void)layout;
@end

