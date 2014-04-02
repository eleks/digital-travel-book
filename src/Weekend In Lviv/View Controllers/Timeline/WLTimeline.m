//
//  WLTimeline.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/25/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLTimeline.h"
#import "WLTopTimelineView.h"
#import "WLMenuButton.h"
#import "UIViewController+MMDrawerController.h"
#import "WLAudioPlayerVC.h"
#import "NSArray+ReverseOrder.h"
#import "WLFontManager.h"


@interface WLTimeline ()


- (void)setupScrollLayer;
- (void)setBottomImage;
- (void)setArrowPositionOnScrollView;
- (void)panOnPoints:(UIPanGestureRecognizer *)sender;
- (void)tapOnPoints:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) WLTopTimelineView *topView;

@property (nonatomic) CGRect oldFrame;
@property (nonatomic) CGPoint oldOffset;
@end


@implementation WLTimeline


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    WLMenuButton *leftDrawerButton = [[WLMenuButton alloc] initWithTarget:self action:@selector(btnMenuTouch:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    WLAudioPlayerVC *playerVC = [WLAudioPlayerVC playerVC];
    [playerVC.view removeFromSuperview];
    self.navigationItem.rightBarButtonItems = [playerVC.toolbar.items reversedArray];

    UIPanGestureRecognizer *panOnPoints = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnPoints:)];
    [self.imgBottom addGestureRecognizer:panOnPoints];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPoints:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.imgBottom addGestureRecognizer:tap];

    self.topView = [[NSBundle mainBundle] loadNibNamed:@"WLTopTimelineView" owner:nil options:nil][0];

    self.topView.frame = CGRectMake(0, 0, self.topView.frame.size.width, 500);

    for (int i = 501; i <= 525; i++) {
        WLTimelineImageView *imgView = (WLTimelineImageView *) [self.viewTimelinePoints viewWithTag:i];
        imgView.delegate = self;
    }

    [self.scrollTimeline addSubview:self.topView];

    self.oldFrame = CGRectMake(0, 0, 768, 1024);

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (int i = 101; i <= 104; i++) {
        UILabel *lblView = (UILabel *) [self.viewCentury viewWithTag:i];
        [lblView setFont:[WLFontManager sharedManager].bebasRegular20];
        [lblView setTextColor:RGB(161, 106, 46)];

        UIButton *btnView = (UIButton *) [self.viewCentury viewWithTag:i * 2];
        [btnView.titleLabel setFont:[WLFontManager sharedManager].bebasRegular20];
        [btnView setTitleColor:RGB(161, 106, 46) forState:UIControlStateNormal];
    }

    [self setupScrollLayer];
    [self setBottomImage];
    [self setArrowPositionOnScrollView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setBottomImage];
    [self setupScrollLayer];

    [self setArrowPositionOnScrollView];
}


- (void)btnMenuTouch:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    self.oldFrame = self.view.frame;
    self.oldOffset = self.scrollTimeline.contentOffset;
}


- (void)setupScrollLayer {
    CGRect viewFrame = self.view.frame;
    self.scrollTimeline.contentSize = self.topView.frame.size;

    self.viewCentury.frame = CGRectMake(0, viewFrame.size.height - self.viewCentury.frame.size.height, viewFrame.size.width, self.viewCentury.frame.size.height);
    self.navigationView.frame = CGRectMake(0, self.viewCentury.frame.origin.y - self.navigationView.frame.size.height, viewFrame.size.width, self.navigationView.frame.size.height);
    self.scrollTimeline.frame = CGRectMake(0, 64, viewFrame.size.width, self.navigationView.frame.origin.y);
    CGFloat scale = self.topView.frame.size.height / self.navigationView.frame.origin.y;
    [self.topView setHeight:self.navigationView.frame.origin.y];
    self.scrollTimeline.contentSize = self.topView.frame.size;
    self.scrollTimeline.contentOffset = CGPointMake(MIN(MAX(((self.oldOffset.x + self.oldFrame.size.width / 2) / scale - self.view.frame.size.width / 2), 0), self.scrollTimeline.contentSize.width - self.scrollTimeline.frame.size.width) /*self.scrollTimeline.contentOffset.x / scale*/, 0);

    CGFloat previousX = 0;
    CGFloat screenScale = self.oldFrame.size.width / self.view.frame.size.width;
    for (NSInteger tag = 101; tag <= 104; tag++) {
        UIView *lblView = [self.viewCentury viewWithTag:tag];
        UIView *btnView = [self.viewCentury viewWithTag:tag * 2];
        CGRect frame = lblView.frame;
        frame.origin.x = previousX;
        frame.size.width /= screenScale;
        lblView.frame = frame;
        previousX = CGRectGetMaxX(frame);
        btnView.frame = frame;
    }
}


- (void)setBottomImage {
    [self.imgBottom setImage:[UIImage imageNamed:@"TimelineBottomBkg.png"]];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat delta = (scrollView.contentSize.width - scrollView.bounds.size.width) / (self.imgBottom.frame.size.width - 18);
    [self.imgArrow setFrame:CGRectMake(scrollView.contentOffset.x / delta - 11, self.imgArrow.frame.origin.y, self.imgArrow.frame.size.width, self.imgArrow.frame.size.height)];

    [self setArrowPositionOnScrollView];
}


- (void)setArrowPositionOnScrollView {
    CGPoint currentPoint = CGPointMake(CGRectGetMidX(self.imgArrow.frame), CGRectGetMaxY(self.imgArrow.frame));
    CGPoint viewTimelinePoint = [self.viewTimelinePoints convertPoint:currentPoint fromView:self.navigationView];

    for (int tag = 501; tag <= 525; tag++) {
        WLTimelineImageView *imgView = (WLTimelineImageView *) [self.viewTimelinePoints viewWithTag:tag];

        if (CGRectGetMinX(imgView.frame) <= viewTimelinePoint.x && CGRectGetMaxX(imgView.frame) >= viewTimelinePoint.x) {
            WLTimelineImageView *activeImgView = (WLTimelineImageView *) [self.viewTimelinePoints viewWithTag:tag];
            [activeImgView becomeFirstResponder];
            break;
        }
    }

    CGPoint currentPointLbl = CGPointMake(self.imgArrow.frame.origin.x + self.imgArrow.frame.size.width / 2, 60);
    for (int tag = 101; tag <= 104; tag++) {
        UILabel *lbl = (UILabel *) [self.viewCentury viewWithTag:tag];
        UIButton *btn = (UIButton *) [self.viewCentury viewWithTag:tag * 2];
        if (CGRectGetMinX(lbl.frame) < currentPointLbl.x && CGRectGetMaxX(lbl.frame) > currentPointLbl.x) {
            [lbl setTextColor:RGB(255, 247, 231)];
            [btn setTitleColor:RGB(255, 247, 231) forState:UIControlStateNormal];
            for (; ++tag <= 104; tag++) {
                [(UILabel *) [self.viewCentury viewWithTag:tag] setTextColor:RGB(161, 106, 46)];
                [(UIButton *) [self.viewCentury viewWithTag:tag * 2] setTitleColor:RGB(161, 106, 46) forState:UIControlStateNormal];
            }
            break;
        }
        else {
            [lbl setTextColor:RGB(161, 106, 46)];
            [btn setTitleColor:RGB(161, 106, 46) forState:UIControlStateNormal];
        }
    }
}


- (void)imageViewDidTouch:(WLTimelineImageView *)imageView {
    CGFloat delta = (self.scrollTimeline.contentSize.width - self.scrollTimeline.bounds.size.width) / (self.imgBottom.frame.size.width - 18);

    CGRect newRect = CGRectMake((imageView.frame.origin.x + imageView.frame.size.width / 2 - 11) * delta, self.scrollTimeline.bounds.origin.y, self.scrollTimeline.bounds.size.width, self.scrollTimeline.bounds.size.height);

    [self.scrollTimeline scrollRectToVisible:newRect animated:YES];

}


- (void)panOnPoints:(UIPanGestureRecognizer *)sender {
    if (sender.numberOfTouches == 1) {
        CGFloat delta = (self.scrollTimeline.contentSize.width - self.scrollTimeline.bounds.size.width) / (self.imgBottom.frame.size.width - 18);
        CGPoint location = [sender locationInView:self.imgBottom];
        CGRect newRect = CGRectMake(location.x * delta - self.imgArrow.frame.size.width / 2, self.scrollTimeline.bounds.origin.y, self.scrollTimeline.bounds.size.width, self.scrollTimeline.bounds.size.height);

        [self.scrollTimeline scrollRectToVisible:newRect animated:NO];
    }
}


- (void)tapOnPoints:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat delta = (self.scrollTimeline.contentSize.width - self.scrollTimeline.bounds.size.width) / (self.imgBottom.frame.size.width - 18);
        CGPoint location = [sender locationInView:self.imgBottom];
        CGRect newRect = CGRectMake(location.x * delta - self.imgArrow.frame.size.width / 2, self.scrollTimeline.bounds.origin.y, self.scrollTimeline.bounds.size.width, self.scrollTimeline.bounds.size.height);

        [self.scrollTimeline scrollRectToVisible:newRect animated:YES];
    }
}


- (IBAction)scrollToMiddle:(UIButton *)sender {
    CGFloat midPoint = CGRectGetMidX(sender.frame);

    CGFloat delta = (self.scrollTimeline.contentSize.width - self.scrollTimeline.bounds.size.width) / (self.imgBottom.frame.size.width - 18);
    CGPoint location = CGPointMake(midPoint, 0);
    CGRect newRect = CGRectMake(location.x * delta - self.imgArrow.frame.size.width / 2, self.scrollTimeline.bounds.origin.y, self.scrollTimeline.bounds.size.width, self.scrollTimeline.bounds.size.height);

    [self.scrollTimeline scrollRectToVisible:newRect animated:YES];
}

@end
