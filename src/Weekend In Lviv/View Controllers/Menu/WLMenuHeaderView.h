//
//  WLMenuHeaderView.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/14/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WLMenuHeaderView : UIView


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *lineLeft;
@property (weak, nonatomic) IBOutlet UIView *lineRight;

- (void)setTitle:(NSString *)titleText;
@end
