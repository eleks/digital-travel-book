//
//  WLArticleVC.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/12/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLArticleVC.h"
#import "WLPointBlockView.h"
#import "WLPhotoGalleryVC.h"
#import "WLDetailVC.h"
#import "WLCoreTextLabel.h"
#import "WLDataManager.h"
#import "WLFontManager.h"
#import "WLPlace.h"
#import "Place.h"


@interface WLArticleVC ()


@property (nonatomic, strong) NSMutableDictionary *textBlocks;
@property (nonatomic, strong) NSMutableDictionary *pointBlocks;
@property (nonatomic) BOOL galleryPresented;


- (void)setScrollLayoutForOrientation:(UIInterfaceOrientation)orientation;
- (void)setDescriptionText:(NSString *)text;

@end


@implementation WLArticleVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.textBlocks = [[NSMutableDictionary alloc] init];
        self.pointBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollDetail.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.galleryPresented = NO;

    self.lblSwipe.font = [WLFontManager sharedManager].gentiumItalic15;
    self.lblFirst.font = [WLFontManager sharedManager].palatinoRegular20;
    self.lblPlaceTitle.font = [WLFontManager sharedManager].bebasRegular100;
    self.btnPlayAudio.titleLabel.font = [WLFontManager sharedManager].bebasRegular16;

    self.lblPlaceTitle.text = self.place.title;

    Place *moPlace = [[WLDataManager sharedManager] placeWithIdentifier:self.place.moIdentificator];
    if ([moPlace.favourite boolValue]) {
        [self.btnAddToFavourites setImage:[UIImage imageNamed:@"BtnFavoriteBkg"] forState:UIControlStateNormal];
    }
    else {
        [self.btnAddToFavourites setImage:[UIImage imageNamed:@"BtnFavoriteBkg_inactive"] forState:UIControlStateNormal];
    }
    
    [self setupSwipeTip];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setScrollLayoutForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}


- (void)viewWillLayoutSubviews {
    [self setScrollLayoutForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [[NSNotificationCenter defaultCenter] postNotificationName:kRotateNotification object:nil];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setScrollLayoutForOrientation:toInterfaceOrientation];
}


- (void)setScrollLayoutForOrientation:(UIInterfaceOrientation)orientation {
    UIImage *topImage = [[WLDataManager sharedManager] imageWithPath:self.place.placeTopImagePath];
    if (topImage) {
        self.imgTop.image = topImage;
    }
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.view.frame = CGRectMake(0, 0, 1024, 768);
        self.imgTop.frame = CGRectMake(0, 0, 1024, 452);
        self.lblPlaceTitle.frame = CGRectMake(self.lblPlaceTitle.frame.origin.x, 40, self.lblPlaceTitle.frame.size.width, self.lblPlaceTitle.frame.size.height);
        self.btnPlayAudio.frame = CGRectMake(self.btnPlayAudio.frame.origin.x, 340, self.btnPlayAudio.frame.size.width, self.btnPlayAudio.frame.size.height);
    }
    else {
        self.view.frame = CGRectMake(0, 0, 768, 1024);
        self.imgTop.frame = CGRectMake(0, 0, 768, 452 * 0.75);
        self.lblPlaceTitle.frame = CGRectMake(self.lblPlaceTitle.frame.origin.x, 20, self.lblPlaceTitle.frame.size.width, self.lblPlaceTitle.frame.size.height);
        self.btnPlayAudio.frame = CGRectMake(self.btnPlayAudio.frame.origin.x, 270, self.btnPlayAudio.frame.size.width, self.btnPlayAudio.frame.size.height);
    }
    self.lblFirst.frame = CGRectMake(self.lblFirst.frame.origin.x, self.imgTop.frame.size.height + 40, self.lblFirst.frame.size.width, self.lblFirst.frame.size.height);

    CGRect textBoundingRec = [self.lblPlaceTitle.text boundingRectWithSize:self.lblPlaceTitle.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lblPlaceTitle.font} context:nil];
    CGSize textSize = !CGRectIsNull(textBoundingRec) ? textBoundingRec.size : CGSizeZero;

    CGRect textRect = CGRectMake(self.lblPlaceTitle.frame.origin.x, self.lblPlaceTitle.frame.origin.y, self.lblPlaceTitle.frame.size.width, textSize.height);
    self.lblPlaceTitle.frame = textRect;
    [self.lblPlaceTitle setNeedsDisplay];

    self.descriptionText = self.place.placeText;

    NSInteger rowsCount = [self.place.placesTextBlocks count];
    CGFloat thumbWidth = self.scrollDetail.frame.size.width;
    CGFloat x = 0;
    CGFloat y = self.lblFirst.frame.origin.y + self.lblFirst.frame.size.height + 40;

    for (NSUInteger i = 1; i <= rowsCount; i++) {
        WLArticleBlock *itemView = self.textBlocks[@(i)];
        if (!itemView) {
            WLTextBlock *textBlock = (self.place.placesTextBlocks)[i - 1];
            itemView = [[NSBundle mainBundle] loadNibNamed:@"WLArticleBlock" owner:nil options:nil][0];
            itemView.layoutWithTextBlock = textBlock;
            itemView.delegate = self;

            self.textBlocks[@(i)] = itemView;
        }
        else {
            [itemView layout];
        }

        itemView.frame = CGRectMake(x, y, thumbWidth, itemView.frame.size.height);
        [self.scrollDetail addSubview:itemView];
        y += itemView.frame.size.height;
    }

    NSInteger pointBlockCount = [self.place.placesPointBlocks count];
    for (NSUInteger i = 1; i <= pointBlockCount; i++) {
        WLPointBlockView *itemView = self.pointBlocks[@(i)];
        if (!itemView) {
            WLPointBlock *pointBlock = (self.place.placesPointBlocks)[i - 1];
            itemView = [[NSBundle mainBundle] loadNibNamed:@"WLPointBlockView" owner:nil options:nil][0];

            itemView.layoutWithPointBlock = pointBlock;

            self.pointBlocks[@(i)] = itemView;
        }
        else {
            [itemView layout];
        }

        itemView.frame = CGRectMake(x, y, thumbWidth, itemView.frame.size.height);
        [self.scrollDetail addSubview:itemView];
        y += itemView.frame.size.height;
    }

    self.swipeLayer.frame = CGRectMake(0, y, self.swipeLayer.frame.size.width, self.swipeLayer.frame.size.height);
    y += self.swipeLayer.frame.size.height;

    CGFloat contentWidth = self.scrollDetail.frame.size.width;
    CGFloat contentHeight = y;
    [self.scrollDetail setContentSize:CGSizeMake(contentWidth, contentHeight)];
}


- (void)setDescriptionText:(NSString *)text {

    if ([text length] > 0) {
        CGFloat lblWidth;
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]/*[[[[[UIApplication sharedApplication] delegate]window]rootViewController]interfaceOrientation]*/)) {
            lblWidth = 944;
        }
        else {
            lblWidth = 688;
        }


        CGSize firstSize = [text boundingRectWithSize:CGSizeMake(lblWidth / 2 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lblFirst.font} context:nil].size;

        self.lblFirst.text = text;
        [self.lblFirst setFrame:CGRectMake(self.lblFirst.frame.origin.x, self.lblFirst.frame.origin.y, lblWidth, firstSize.height / 2 + 40)];

    }
    else {
        self.lblFirst.text = @"";
    }
}


- (void)pushControllerWithAnimation:(UIViewController *)controller fromView:(UIView *)view {

    __weak typeof (self) weakSelf = self;

    __block UIImageView *transitionView = [[UIImageView alloc] initWithFrame:view.frame];
    transitionView.image = ((UIImageView *) view).image;
    [view.superview addSubview:transitionView];
    view.hidden = YES;
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
            [strongSelf.navigationController pushViewController:controller animated:NO];
            strongSelf.view.userInteractionEnabled = YES;
            strongSelf.galleryPresented = NO;
            view.hidden = NO;
        }];
    }];
}

- (IBAction)btnBackwardTouch:(id)sender {
    WLDetailVC *detailController = (WLDetailVC *)self.parentViewController.parentViewController;
    [detailController switchToPreviousViewControllerAnimated:YES];
}


- (IBAction)btnForwardTouch:(id)sender {
    WLDetailVC *detailController = (WLDetailVC *)self.parentViewController.parentViewController;
    [detailController switchToNextViewControllerAnimated:YES];
}


- (IBAction)btnPlayAudioTouch:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playAudioFile" object:self userInfo:@{@"file": self.place.placeAudioPath}];
}


- (IBAction)btnAddToFavouriteTouch:(id)sender {
    Place *moPlace = [[WLDataManager sharedManager] placeWithIdentifier:self.place.moIdentificator];
    if (moPlace) {
        if ([moPlace.favourite boolValue]) {
            moPlace.favourite = @NO;
            self.place.placeFavourite = NO;
            [self.btnAddToFavourites setImage:[UIImage imageNamed:@"BtnFavoriteBkg_inactive"] forState:UIControlStateNormal];
        }
        else {
            moPlace.favourite = @YES;
            self.place.placeFavourite = YES;
            [self.btnAddToFavourites setImage:[UIImage imageNamed:@"BtnFavoriteBkg"] forState:UIControlStateNormal];
        }
        [[WLDataManager sharedManager] saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ArticleStatusChanged" object:nil];
    }
}


- (void)tapOnImageWithPath:(NSString *)imagePath imageContainer:(UIImageView *)imageView {
    if (!self.galleryPresented) {
        self.view.userInteractionEnabled = NO;
        self.galleryPresented = YES;

        WLPhotoGalleryVC *photoVC = [[WLPhotoGalleryVC alloc] initWithNibName:@"WLPhotoGalleryVC" bundle:nil];
        photoVC.imagePathList = [[WLDataManager sharedManager] imageListWithPlace:self.place];
        NSUInteger index = [photoVC.imagePathList indexOfObject:imagePath];
        if (index != NSNotFound) {
            photoVC.selectedImageIndex = index;
        }

        photoVC.view.frame = self.view.frame;


        [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePlayer" object:nil];
        [self pushControllerWithAnimation:photoVC fromView:imageView];
    }
}

- (void)setPlace:(WLPlace *)place {
    _place = place;
    [self setupSwipeTip];
    
}

- (void)setupSwipeTip {
    NSUInteger index = [[WLDataManager sharedManager].placesList indexOfObject:self.place];
    if (index == 0) {
        self.lblSwipe.text = @"swipe right";
    }
    else if (index == [[WLDataManager sharedManager].placesList count] - 1) {
        self.lblSwipe.text = @"swipe left";
    }
}


- (void)scrollToTop {
    self.scrollDetail.contentOffset = CGPointMake(0, -64);
}
@end
