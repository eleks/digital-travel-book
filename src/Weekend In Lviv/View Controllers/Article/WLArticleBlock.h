//
//  WLArticleBlock.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/12/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

@class WLCoreTextLabel;
@class WLTextBlock;


@protocol WLDetailBlockDelegate <NSObject>


- (void)tapOnImageWithPath:(NSString *)imagePath imageContainer:(UIImageView *)imageView;

@end


@interface WLArticleBlock : UIView

@property (weak, nonatomic) id <WLDetailBlockDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
@property (weak, nonatomic) IBOutlet WLCoreTextLabel *lblFirstColumn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImages;
@property (weak, nonatomic) IBOutlet UIView *textLayer;

- (void)setLayoutWithTextBlock:(WLTextBlock *)textBlock;
- (void)layout;

@end
