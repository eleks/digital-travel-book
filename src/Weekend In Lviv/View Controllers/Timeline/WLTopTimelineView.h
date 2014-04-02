//
//  WLTopTimelineView.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/25/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WLTopTimelineView : UIView


@property (weak, nonatomic) IBOutlet UIView *yearsView;

- (void)setHeight:(CGFloat)height;
@end
