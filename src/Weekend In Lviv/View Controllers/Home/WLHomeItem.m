//
//  WLHomeItem.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/12/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLHomeItem.h"
#import "WLFontManager.h"


@implementation WLHomeItem


- (void)awakeFromNib {
    self.lblCategory.font = [WLFontManager sharedManager].palatinoRegular12;
    self.lblTitle.font = [WLFontManager sharedManager].bebasRegular32;
}

@end
