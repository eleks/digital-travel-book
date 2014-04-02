//
//  WLTimelineImageView.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/27/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLTimelineImageView.h"


@implementation WLTimelineImageView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (BOOL)resignFirstResponder {
    [self setHighlighted:NO];
    return [super resignFirstResponder];
}


- (BOOL)becomeFirstResponder {
    [self setHighlighted:YES];
    return [super becomeFirstResponder];
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewDidTouch:)]) {
            [self.delegate imageViewDidTouch:self];
        }
    }
}

@end
