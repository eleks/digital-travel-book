//
// Created by Viktor Malieichyk on 3/13/14.
// Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WLDetailVC : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>


- (id)initWithItemIndex:(NSUInteger)index;

- (void)switchToViewControllerWithIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)switchToPreviousViewControllerAnimated:(BOOL)animated;
- (void)switchToNextViewControllerAnimated:(BOOL)animated;
@end