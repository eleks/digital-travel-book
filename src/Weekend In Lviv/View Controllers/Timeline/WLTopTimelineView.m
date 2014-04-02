//
//  WLTopTimelineView.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/25/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLTopTimelineView.h"
#import "WLFontManager.h"


@implementation WLTopTimelineView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    for (int i = 1; i <= 24; i++) {
        UILabel *lbl = (UILabel *) [self viewWithTag:i];
        if ([lbl isKindOfClass:[UILabel class]]) {
            [lbl setFont:[WLFontManager sharedManager].bebasRegular22];
        }
    }
}


- (void)setHeight:(CGFloat)height {
    CGFloat ratio = self.frame.size.width / self.frame.size.height;
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, height * ratio, height);
    self.frame = newFrame;

    self.yearsView.frame = CGRectMake(0, (self.frame.size.height + 10) * 0.88, self.frame.size.width, self.yearsView.frame.size.height);
}

@end
