//
//  WLMapVC.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/13/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLMapVC.h"


@interface WLMapVC ()

@end


@implementation WLMapVC


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


- (IBAction)btnBackTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
