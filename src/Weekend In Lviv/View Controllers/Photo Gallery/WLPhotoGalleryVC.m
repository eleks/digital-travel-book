//
//  WLPhotoGalleryVC.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/14/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLPhotoGalleryVC.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "WLFontManager.h"


@interface ImageViewController : UIViewController


@property (nonatomic) NSUInteger index;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) UIImageView *imageView;
@end


@implementation ImageViewController


- (void)setImagePath:(NSString *)imagePath {
    _imagePath = imagePath;

    [self.imageView removeFromSuperview];
    self.imageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:self.imagePath]];
    self.imageView.frame = self.view.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = self.imageView;
}

@end


@interface WLPhotoGalleryVC ()

@property (nonatomic, strong) UIPageViewController *pageController;

@end


@implementation WLPhotoGalleryVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.lblSwipe.font = [WLFontManager sharedManager].gentiumItalic15;

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    UIViewController *initialViewController = [self viewControllerAtIndex:self.selectedImageIndex];

    if (initialViewController) {
        [self.pageController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
    [self addChildViewController:self.pageController];
    [self.view addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.pageController.dataSource = self;
    self.pageController.view.frame = self.view.bounds;

    self.pageController.view.frame = self.scrollImages.frame;
    [self.view addSubview:self.pageController.view];

    [self.view bringSubviewToFront:self.btnClose];
    [self.view bringSubviewToFront:self.lblSwipe];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPlayer" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


- (void)btnMenuTouch:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


- (IBAction)btnCloseTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Page view controller delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    ImageViewController *imageController = (ImageViewController *) viewController;
    return [self viewControllerAtIndex:imageController.index - 1];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    ImageViewController *imageController = (ImageViewController *) viewController;
    return [self viewControllerAtIndex:imageController.index + 1];
}


- (ImageViewController *)viewControllerAtIndex:(NSUInteger)index {
    ImageViewController *photoVC = nil;


    if (index < [self.imagePathList count]) {
        photoVC = [[ImageViewController alloc] init];
        photoVC.imagePath = self.imagePathList[index];
        photoVC.index = index;
    }

    return photoVC;
}

@end
