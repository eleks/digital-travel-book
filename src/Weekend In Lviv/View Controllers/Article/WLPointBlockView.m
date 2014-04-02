//
//  WLPointBlockView.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/20/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "WLPointBlockView.h"
#import "WLPointVC.h"
#import "WLPointBlock.h"
#import "WLFontManager.h"
#import "WLDataManager.h"
#import "UIScreen+SSToolkitAdditions.h"
#import "WLPoint.h"


@interface WLPointBlockView (
private)


- (void)setDescriptionText:(NSString *)text;
- (void)btnTouch:(UIButton *)sender;
- (void)willRotate:(NSNotification *)notification;
@end


@interface WLPointBlockView ()


@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) WLPointBlock *currentBlock;
@end


@implementation WLPointBlockView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    _imgBtnNormal = [UIImage imageNamed:@"btnPointNormal.png"];
    _imgBtnHighlighted = [UIImage imageNamed:@"btnPointHightlight.png"];
    _imgBtnSelected = [UIImage imageNamed:@"btnPointSelected.png"];
    self.lblFirst.font = [WLFontManager sharedManager].palatinoRegular20;
    _pointShowing = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRotate:) name:kRotateNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmiss) name:@"Toggled drawer" object:nil];
}


#pragma mark - Keyboard notification
- (void)setLayoutWithPointBlock:(WLPointBlock *)pointBlock {
    self.currentBlock = pointBlock;
    [self layout];
}


- (void)dismissPopover {
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    for (int i = 0; i < [self.currentBlock.blockPoints count]; i++) {
        UIButton *btn = (UIButton *) [self viewWithTag:100 + i];
        if (btn) {
            [btn setSelected:NO];
        }
    }
    _pointShowing = NO;
}


- (void)willRotate:(NSNotification *)notification {
    if (self.popover) {
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
        for (int i = 0; i < [self.currentBlock.blockPoints count]; i++) {
            UIButton *btn = (UIButton *) [self viewWithTag:100 + i];
            [btn setSelected:NO];
        }
    }
    _pointShowing = NO;
}


- (void)btnTouch:(UIButton *)sender {
    if (!_pointShowing) {
        _pointShowing = YES;

        UIViewController *viewController = [[UIViewController alloc] init];
        if ([viewController mm_drawerController].openSide != MMDrawerSideNone) {
            [[viewController mm_drawerController] toggleDrawerSide:MMDrawerSideNone animated:YES completion:nil];
        }

        for (int i = 0; i < [self.currentBlock.blockPoints count]; i++) {
            UIButton *btn = (UIButton *) [self viewWithTag:100 + i];
            [btn setSelected:btn.tag == sender.tag];
        }
        WLPoint *point = (self.currentBlock.blockPoints)[(NSUInteger) (sender.tag - 100)];
        WLPointVC *pointVC = [[WLPointVC alloc] initWithNibName:@"WLPointVC" bundle:nil];

        self.popover = [[UIPopoverController alloc] initWithContentViewController:pointVC];
        self.popover.delegate = self;
        [pointVC setDetailWithPoint:point];
        self.popover.popoverContentSize = pointVC.view.frame.size;
        [self.popover presentPopoverFromRect:sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}


- (void)dissmiss {
    [self dismissPopover];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {

    for (int i = 0; i < [self.currentBlock.blockPoints count]; i++) {
        UIButton *btn = (UIButton *) [self viewWithTag:100 + i];
        if (btn) {
            [btn setSelected:NO];
        }
    }
    return YES;
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    _pointShowing = NO;
    self.popover = nil;
}


- (void)setDescriptionText:(NSString *)text {
    if ([text length] > 0) {
        CGFloat lblWidth;
        if (UIInterfaceOrientationIsLandscape([[[[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation])) {
            lblWidth = 944;
        }
        else {
            lblWidth = 688;
        }

        CGSize firstSize = [text boundingRectWithSize:CGSizeMake(lblWidth / 2 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lblFirst.font} context:nil].size;

        self.lblFirst.text = text;
        [self.lblFirst setFrame:CGRectMake(self.lblFirst.frame.origin.x, self.lblFirst.frame.origin.y, self.lblFirst.frame.size.width, firstSize.height / 2)];
        [self.textView setFrame:CGRectMake(0, self.imgMain.frame.size.height + 20, self.frame.size.width, self.lblFirst.frame.origin.y + firstSize.height / 2 + 40)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textView.frame.origin.y + self.textView.frame.size.height)];
    }
    else {
        self.lblFirst.text = @"";
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)layout {
    UIImage *img = [[WLDataManager sharedManager] imageWithPath:self.currentBlock.blockImagePath];
    [self.imgMain setImage:img];
    if ([[UIScreen mainScreen] isRetinaDisplay]) {
        if (UIInterfaceOrientationIsLandscape([[[[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation])) {
            [self.imgMain setFrame:CGRectMake(0, 0, self.imgMain.frame.size.width, img.size.height / 2)];
        }
        else {
            [self.imgMain setFrame:CGRectMake(0, 0, self.imgMain.frame.size.width, img.size.height * 0.75 / 2)];
        }

    }
    else if (UIInterfaceOrientationIsLandscape([[[[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation])) {
        [self.imgMain setFrame:CGRectMake(0, 0, self.imgMain.frame.size.width, img.size.height)];
    }
    else {
        [self.imgMain setFrame:CGRectMake(0, 0, self.imgMain.frame.size.width, img.size.height * 0.75)];
    }

    [self setDescriptionText:self.currentBlock.blockText];
    for (NSUInteger i = 0; i < [self.currentBlock.blockPoints count]; i++) {
        WLPoint *point = (self.currentBlock.blockPoints)[i];
        UIButton *button = (UIButton *) [self viewWithTag:100 + i];
        if (!button) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:_imgBtnNormal forState:UIControlStateNormal];
            [button setBackgroundImage:_imgBtnHighlighted forState:UIControlStateHighlighted];
            [button setBackgroundImage:_imgBtnSelected forState:UIControlStateSelected];
            [button addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            [self addSubview:button];
        }
        if (UIInterfaceOrientationIsLandscape([[[[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation])) {
            [button setFrame:CGRectMake(point.x / 2, point.y / 2, 50, 50)];
        }
        else {
            [button setFrame:CGRectMake(point.x / 2 * 0.75, point.y / 2 * 0.75, 50, 50)];
        }

    }

}

@end
