//
// Created by Viktor Malieichyk on 3/4/14.
// Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WLNavigationController : UINavigationController <UINavigationControllerDelegate>


@property (nonatomic, copy) dispatch_block_t completionBlock;
@property (nonatomic, strong) UIViewController *pushedVC;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completion;
@end
