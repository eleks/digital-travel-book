//
//  WLMenuCell.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/14/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLMenuCell.h"
#import "WLFontManager.h"


@implementation WLMenuCell


- (void)awakeFromNib {
    self.lblTitle.font = [WLFontManager sharedManager].palatinoItalic20;
}


@end
