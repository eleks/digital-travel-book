//
//  WLMenuHeaderView.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/14/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLMenuHeaderView.h"
#import "WLFontManager.h"


@implementation WLMenuHeaderView


- (void)awakeFromNib {
    self.lblTitle.font = [WLFontManager sharedManager].bebasRegular16;
}


- (void)setTitle:(NSString *)titleText {
    self.lblTitle.text = titleText;
    [self.lblTitle sizeToFit];
    [self.lblTitle setFrame:CGRectMake((self.frame.size.width - self.lblTitle.frame.size.width) / 2, (self.frame.size.height - self.lblTitle.frame.size.height) / 2, self.lblTitle.frame.size.width, self.lblTitle.frame.size.height)];
    [self.lineLeft setFrame:CGRectMake(10,
                                       (self.frame.size.height - self.lineLeft.frame.size.height) / 2,
                                       self.lblTitle.frame.origin.x - 30,
                                       self.lineLeft.frame.size.height)];
    [self.lineRight setFrame:CGRectMake(self.lblTitle.frame.origin.x + self.lblTitle.frame.size.width + 10,
                                        (self.frame.size.height - self.lineRight.frame.size.height) / 2,
                                        self.frame.size.width - (self.lblTitle.frame.origin.x + self.lblTitle.frame.size.width + 30),
                                        self.lineRight.frame.size.height)];
}

@end
