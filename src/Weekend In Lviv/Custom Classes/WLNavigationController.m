//
// Created by Viktor Malieichyk on 3/4/14.
// Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import "WLNavigationController.h"
#import "UIViewController+MMDrawerController.h"


@implementation WLNavigationController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.completionBlock && self.pushedVC == viewController) {
        self.completionBlock();
        self.completionBlock = nil;
        self.pushedVC = nil;
    }
    else if (self.completionBlock && viewController == [self.viewControllers firstObject]) {
        self.completionBlock();
        self.completionBlock = nil;
    }

}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.pushedVC != viewController && viewController != [self.viewControllers firstObject]) {
        self.pushedVC = nil;
        self.completionBlock = nil;
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion {
    self.pushedVC = viewController;
    self.completionBlock = completion;
    [self pushViewController:viewController animated:animated];
}


@end