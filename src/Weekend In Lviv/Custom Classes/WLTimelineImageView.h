//
//  WLTimelineImageView.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/27/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WLTimelineImageView;


@protocol WLTimelineImageViewDelegate <NSObject>


- (void)imageViewDidTouch:(WLTimelineImageView *)imageView;

@end


@interface WLTimelineImageView : UIImageView


@property (strong, nonatomic) id <WLTimelineImageViewDelegate> delegate;

@end
