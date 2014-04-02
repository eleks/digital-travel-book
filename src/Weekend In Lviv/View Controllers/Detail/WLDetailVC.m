//
// Created by Viktor Malieichyk on 3/13/14.
// Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import "WLDetailVC.h"
#import "WLArticleVC.h"
#import "UIViewController+MMDrawerController.h"
#import "WLMenuButton.h"
#import "WLAudioPlayerVC.h"
#import "NSArray+ReverseOrder.h"
#import "WLDataManager.h"


@interface WLDetailVC ()


@property (nonatomic, strong) NSCache *viewControllersCache;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic) NSUInteger currentIndex;
@end


@implementation WLDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey : @(30)}];
    self.pageController.view.backgroundColor = RGB(48, 23, 0);


    self.pageController.dataSource = self;
    self.pageController.delegate = self;

    [[self.pageController view] setFrame:[[self view] bounds]];

    WLArticleVC *initialViewController = [self viewControllerAtIndex:self.currentIndex];

    [self.pageController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];

    WLAudioPlayerVC *playerVC = [WLAudioPlayerVC playerVC];
    [playerVC.view removeFromSuperview];
    self.navigationItem.rightBarButtonItems = [playerVC.toolbar.items reversedArray];

    WLMenuButton *leftDrawerButton = [[WLMenuButton alloc] initWithTarget:self action:@selector(btnMenuTouch:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    self.viewControllersCache = [[NSCache alloc] init];
    [self.viewControllersCache setCountLimit:3];

}


- (void)btnMenuTouch:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Toggled drawer" object:nil];
}


- (id)initWithItemIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        self.currentIndex = index;
    }

    return self;

}


- (void)switchToViewControllerWithIndex:(NSUInteger)index animated:(BOOL)animated {
    if (self.currentIndex == index) {
        return;
    }
    if (index < [[WLDataManager sharedManager].placesList count]) {
        UIViewController *controller = [self viewControllerAtIndex:index];
        UIPageViewControllerNavigationDirection direction = (index > self.currentIndex) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        __block WLDetailVC *blockSafeSelf = self;
        [self.pageController setViewControllers:@[controller] direction:direction animated:animated completion:^(BOOL finished) {
            if (finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [blockSafeSelf.pageController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];// bug fix for uipageview controller
                });
            }
        }];
        self.currentIndex = index;
    }

}


#pragma mark - UIPageViewControllerDataSource

- (WLArticleVC *)viewControllerAtIndex:(NSUInteger)index {
    WLArticleVC *detailVC = [self.viewControllersCache objectForKey:@(index)];
    if (index < [[WLDataManager sharedManager].placesList count]) {
        WLPlace *place = ([WLDataManager sharedManager].placesList)[index];
        detailVC = [[WLArticleVC alloc] initWithNibName:@"WLArticleVC" bundle:nil];
        detailVC.place = place;
        [self.viewControllersCache setObject:detailVC forKey:@(index)];
    }
    return detailVC;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [[WLDataManager sharedManager].placesList indexOfObject:((WLArticleVC *) viewController).place];
    return [self viewControllerAtIndex:index - 1];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [[WLDataManager sharedManager].placesList indexOfObject:((WLArticleVC *) viewController).place];
    return [self viewControllerAtIndex:index + 1];
}


#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {

    self.currentIndex = [[WLDataManager sharedManager].placesList indexOfObject:((WLArticleVC *) [pendingViewControllers firstObject]).place];

    for (WLArticleVC *article in pendingViewControllers) {
        [article scrollToTop];
    }
}


- (void)switchToPreviousViewControllerAnimated:(BOOL)animated {
    [self switchToViewControllerWithIndex:self.currentIndex - 1 animated:animated];
}


- (void)switchToNextViewControllerAnimated:(BOOL)animated {
    [self switchToViewControllerWithIndex:self.currentIndex + 1 animated:animated];
}

@end