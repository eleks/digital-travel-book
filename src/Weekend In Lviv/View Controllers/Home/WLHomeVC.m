//
//  WLHomeVC.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/11/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#define kColumnIndent 2

#import "WLHomeVC.h"
#import "WLHomeItem.h"
#import "WLTimeline.h"
#import "WLNavigationController.h"
#import "WLMenuButton.h"
#import "UIViewController+MMDrawerController.h"
#import "WLDetailVC.h"
#import "WLAudioPlayerVC.h"
#import "NSArray+ReverseOrder.h"
#import "WLFontManager.h"
#import "WLDataManager.h"
#import "WLPlace.h"


@interface WLHomeVC ()


- (void)setLabelsLayout;
- (void)setScrollLayout;
- (void)setTimelineLayer;
- (void)tapOnItem:(UITapGestureRecognizer *)sender;
- (void)tapOnTimeline:(UITapGestureRecognizer *)sender;


- (void)pushControllerWithAnimation:(UIViewController *)controller fromView:(UIView *)view;

@property (nonatomic, strong) NSMutableDictionary *itemViews;
@property (nonatomic) BOOL detailShowing;
@property (nonatomic, strong) WLDetailVC *detailVC;
@end


@implementation WLHomeVC

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    WLAudioPlayerVC *playerVC = [WLAudioPlayerVC playerVC];
    [playerVC.view removeFromSuperview];
    self.navigationItem.rightBarButtonItems = [playerVC.toolbar.items reversedArray];

    WLMenuButton *leftDrawerButton = [[WLMenuButton alloc] initWithTarget:self action:@selector(btnMenuTouch:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    self.detailShowing = NO;

    [self setLabelsLayout];
    UITapGestureRecognizer *tapOnTimeline = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnTimeline:)];
    tapOnTimeline.numberOfTapsRequired = 1;
    tapOnTimeline.numberOfTouchesRequired = 1;
    [self.viewTimeLine addGestureRecognizer:tapOnTimeline];

    self.itemViews = [[NSMutableDictionary alloc] init];
    
    [self startAnimation];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setScrollLayout];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setScrollLayout];
}


- (void)viewDidLayoutSubviews {
    [self setScrollLayout];
}


- (void)setLabelsLayout {
    self.lblMainTitle.font = [WLFontManager sharedManager].bebasRegular120;
    self.lblMainSubtitle.font = [WLFontManager sharedManager].gentiumRegular12;

    for (int i = 601; i <= 603; i++) {
        UILabel *lbl = (UILabel *) [self.viewTimelineLeft viewWithTag:i];
        [lbl setFont:[WLFontManager sharedManager].palatinoItalic20];
    }

    for (int i = 604; i <= 606; i++) {
        UILabel *lbl = (UILabel *) [self.viewTimelineRight viewWithTag:i];
        [lbl setFont:[WLFontManager sharedManager].palatinoItalic20];
    }

    self.lblMainTitle.userInteractionEnabled = YES;
}


- (void)setScrollLayout {

    NSInteger columnsCount;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        columnsCount = 2;

        [self.imgHeaderImage setFrame:CGRectMake(0, 0, self.imgHeaderImage.frame.size.width, 329 * 0.75)];
        CGFloat delta = 329 * 0.25 / 2;

        [self.imgMainTitle setFrame:CGRectMake(self.imgMainTitle.frame.origin.x, 65 - delta, self.imgMainTitle.frame.size.width, self.imgMainTitle.frame.size.height)];
        [self.lblMainTitle setFrame:CGRectMake(self.lblMainTitle.frame.origin.x, 126 - delta, self.lblMainTitle.frame.size.width, self.lblMainTitle.frame.size.height)];
        [self.lblMainSubtitle setFrame:CGRectMake(self.lblMainSubtitle.frame.origin.x, 102 - delta, self.lblMainSubtitle.frame.size.width, self.lblMainSubtitle.frame.size.height)];

    }
    else {
        columnsCount = 3;
        [self.imgHeaderImage setFrame:CGRectMake(0, 0, self.imgHeaderImage.frame.size.width, 329)];
        [self.imgMainTitle setFrame:CGRectMake(self.imgMainTitle.frame.origin.x, 65, self.imgMainTitle.frame.size.width, self.imgMainTitle.frame.size.height)];
        [self.lblMainTitle setFrame:CGRectMake(self.lblMainTitle.frame.origin.x, 126, self.lblMainTitle.frame.size.width, self.lblMainTitle.frame.size.height)];
        [self.lblMainSubtitle setFrame:CGRectMake(self.lblMainSubtitle.frame.origin.x, 102, self.lblMainSubtitle.frame.size.width, self.lblMainSubtitle.frame.size.height)];
    }
    [self.viewTimeLine setFrame:CGRectMake(0, self.imgHeaderImage.frame.size.height, self.viewTimeLine.frame.size.width, self.viewTimeLine.frame.size.height)];
    [self setTimelineLayer];

    NSInteger itemCount = [[WLDataManager sharedManager].placesList count];

    // Space between each thumbnail
    CGFloat thumbWidth = (self.scrollHome.frame.size.width - (columnsCount - 1) * kColumnIndent) / columnsCount;
    CGFloat thumbHeight = thumbWidth * 0.73529412f;
    CGFloat x = 0;
    CGFloat y = self.viewTimeLine.frame.origin.y + self.viewTimeLine.frame.size.height;

    for (NSUInteger i = 1; i <= itemCount; i++) {
        WLPlace *place = ([WLDataManager sharedManager].placesList)[i - 1];

        WLHomeItem *itemView = self.itemViews[@(i)];
        if (!itemView) {
            itemView = [[NSBundle mainBundle] loadNibNamed:@"WLHomeItem" owner:nil options:nil][0];
            [itemView.imgPhoto setImage:[[WLDataManager sharedManager] imageWithPath:place.listImagePath]];
            self.itemViews[@(i)] = itemView;
        }
        [itemView.lblCategory setText:@"Architecture"];
        [itemView.lblTitle setText:place.title];
        [itemView setFrame:CGRectMake(x, y, thumbWidth, thumbHeight)];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnItem:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [itemView addGestureRecognizer:tap];

        itemView.tag = i;

        [self.scrollHome addSubview:itemView];
        if (i % columnsCount == 0) {
            y += kColumnIndent + thumbHeight;
            x = 0;
        }
        else {
            x += kColumnIndent + thumbWidth;
        }
    }

    CGFloat contentWidth = columnsCount * (kColumnIndent + thumbWidth) - kColumnIndent;
    [self.scrollHome setContentSize:CGSizeMake(contentWidth, y)];
}


- (void)setTimelineLayer {
    self.lblTimelineTop.font = [WLFontManager sharedManager].palatinoRegular12;
    self.lblTimelineTitle.font = [WLFontManager sharedManager].bebasRegular44;
    self.lblTimelineSubtitle.font = [WLFontManager sharedManager].palatinoItalic15;
    [self.lblTimelineSubtitle sizeToFit];
    [self.lblTimelineTitle sizeToFit];
    [self.lblTimelineTop sizeToFit];
    [self.lblTimelineTitle setFrame:CGRectMake((self.viewTimeLine.frame.size.width - self.lblTimelineTitle.frame.size.width) / 2, (self.viewTimeLine.frame.size.height - self.lblTimelineTitle.frame.size.height) / 2, self.lblTimelineTitle.frame.size.width, self.lblTimelineTitle.frame.size.height)];
    [self.lblTimelineTop setFrame:CGRectMake((self.viewTimeLine.frame.size.width - self.lblTimelineTop.frame.size.width) / 2, self.lblTimelineTitle.frame.origin.y - self.lblTimelineTop.frame.size.height, self.lblTimelineTop.frame.size.width, self.lblTimelineTop.frame.size.height)];
    [self.lblTimelineSubtitle setFrame:CGRectMake((self.viewTimeLine.frame.size.width - self.lblTimelineSubtitle.frame.size.width) / 2, self.lblTimelineTitle.frame.origin.y + self.lblTimelineTitle.frame.size.height, self.lblTimelineSubtitle.frame.size.width, self.lblTimelineSubtitle.frame.size.height)];
    [self.viewTimelineLeft setFrame:CGRectMake(0, 0, self.lblTimelineTitle.frame.origin.x - 20, self.viewTimelineLeft.frame.size.height)];
    [self.viewTimelineRight setFrame:CGRectMake(self.lblTimelineTitle.frame.origin.x + self.lblTimelineTitle.frame.size.width + 20, 0, self.viewTimeLine.frame.size.width - (self.lblTimelineTitle.frame.origin.x + self.lblTimelineTitle.frame.size.width + 20), self.viewTimelineRight.frame.size.height)];
}


- (void)tapOnItem:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded && !self.detailShowing) {
        self.detailShowing = YES;
        self.view.userInteractionEnabled = NO;
        NSUInteger index = (NSUInteger) (sender.view.tag - 1);
        self.detailVC = [[WLDetailVC alloc] initWithItemIndex:index];
        [self pushControllerWithAnimation:self.detailVC fromView:sender.view];
    }
}


- (void)tapOnTimeline:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        WLTimeline *timelineVC = [[WLTimeline alloc] initWithNibName:@"WLTimeline" bundle:nil];
        [(WLNavigationController *) self.navigationController pushViewController:timelineVC animated:YES];
    }
}


- (IBAction)btnMenuTouch:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (void)pushControllerWithAnimation:(UIViewController *)controller fromView:(UIView *)view {
    __weak typeof (self) weakSelf = self;

    __block UIImageView *transitionView = [[UIImageView alloc] initWithFrame:view.frame];
    transitionView.image = ((WLHomeItem *) view).imgPhoto.image;
    [view.superview addSubview:transitionView];
    view.hidden = YES;

    controller.view.frame = self.view.bounds;

    [UIView animateWithDuration:kPushAnimationDuration animations:^{
        CATransform3D moveY = CATransform3DMakeTranslation(0, 0, transitionView.frame.size.height);
        CATransform3D rotateView = CATransform3DMakeRotation(0.0174532925f * -90, 1, 0, 0);
        CATransform3D finishedTransform = CATransform3DConcat(rotateView, moveY);
        transitionView.layer.transform = finishedTransform;
    }                completion:^(BOOL finished) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        CATransform3D viewTransform = transitionView.layer.transform;
        CATransform3D controllerScale = CATransform3DMakeScale(transitionView.frame.size.width / controller.view.frame.size.width, transitionView.frame.size.height / controller.view.frame.size.height, 0);

        CATransform3D controllerFinishedTransform = CATransform3DConcat(viewTransform, controllerScale);
        controller.view.layer.transform = controllerFinishedTransform;

        CGRect viewRect = [transitionView convertRect:transitionView.bounds toView:strongSelf.view];
        CGRect controllerRect = controller.view.frame;

        CGFloat controllerTransY = viewRect.origin.y - controllerRect.origin.y;
        CGFloat controllerTransX = viewRect.origin.x - controllerRect.origin.x;
        CATransform3D controllerTranslate = CATransform3DMakeTranslation(controllerTransX, controllerTransY, 0);
        CATransform3D controllerTransform = CATransform3DConcat(controller.view.layer.transform, controllerTranslate);

        controller.view.layer.transform = controllerTransform;

        [strongSelf.view addSubview:controller.view];


        [UIView animateWithDuration:kPushAnimationDuration animations:^{
            controller.view.layer.transform = CATransform3DIdentity;
        }                completion:^(BOOL done) {
            [(WLNavigationController *) strongSelf.navigationController pushViewController:controller animated:NO];
            strongSelf.view.userInteractionEnabled = YES;
            strongSelf.detailShowing = NO;
            view.hidden = NO;
        }];
    }];
}


- (void)switchToViewControllerWithIndex:(NSUInteger)index animated:(BOOL)animated {
    if (!self.detailVC) {
        self.view.userInteractionEnabled = NO;
        WLHomeItem *sender = [self.itemViews allValues][index];
        self.detailVC = [[WLDetailVC alloc] initWithItemIndex:index];
        [self pushControllerWithAnimation:self.detailVC fromView:sender];
    }
    else {
        [self.navigationController popToViewController:self.detailVC animated:NO];
        [self.detailVC switchToViewControllerWithIndex:index animated:animated];
    }
}


- (void)popToRootAnimated:(BOOL)animated {
    if ([self.navigationController.viewControllers count] > 1) {
        [(WLNavigationController *) self.navigationController popToRootViewControllerAnimated:animated];
        self.detailVC = nil;
    }

}


#pragma mark - Animation

- (void)startAnimation {
    CGFloat delay = 0.0;
    for (NSUInteger i = 0; i < 3; i++) {
        UIImageView *leftPoint = self.yearPoints[i];
        UIImageView *rightPoint = self.yearPointsRight[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self flashOn:leftPoint];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self flashOn:rightPoint];
        });
        delay += 0.8;
    }
}

- (void)flashOff:(UIView *)v {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = .2;  //don't animate alpha to 0, otherwise you won't be able to interact with it
    } completion:^(BOOL finished) {
        [self flashOn:v];
    }];
}

- (void)flashOn:(UIView *)v {
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = 1;
    } completion:^(BOOL finished) {
        [self flashOff:v];
    }];
}


@end
