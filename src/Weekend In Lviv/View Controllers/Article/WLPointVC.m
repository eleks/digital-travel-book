//
//  WLPointVC.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/20/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLPointVC.h"
#import "WLPoint.h"
#import "WLFontManager.h"
#import "WLDataManager.h"
#import "UIScreen+SSToolkitAdditions.h"


@interface WLPointVC ()

@end


@implementation WLPointVC


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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {

    return YES;
}


- (void)setDetailWithPoint:(WLPoint *)point {
    [self.view setNeedsDisplay];
    self.lblDescription.font = [WLFontManager sharedManager].gentiumRegular16;
    UIImage *image = [[WLDataManager sharedManager] imageWithPath:point.imagePath];
    [self.imgMain setImage:image];
    if ([[UIScreen mainScreen] isRetinaDisplay]) {
        [self.imgMain setFrame:CGRectMake(0, 0, image.size.width / 2, image.size.height / 2)];
    }
    else {
        [self.imgMain setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    }

    CGSize lblSize = [point.text boundingRectWithSize:CGSizeMake(self.imgMain.frame.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lblDescription.font} context:nil].size;

    CGRect lblRect = CGRectMake(20, self.imgMain.frame.size.height + 20, self.imgMain.frame.size.width - 40, lblSize.height);
    self.lblDescription.text = point.text;
    [self.lblDescription setFrame:lblRect];

    [self.view setFrame:CGRectMake(0, 0, self.imgMain.frame.size.width, self.imgMain.frame.size.height)];
}


@end
