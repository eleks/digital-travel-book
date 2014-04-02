//
//  WLArticleBlock.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/12/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLArticleBlock.h"
#import "WLImageView.h"
#import "WLCoreTextLabel.h"
#import "WLTextBlock.h"
#import "WLFontManager.h"
#import "WLDataManager.h"
#import "UIScreen+SSToolkitAdditions.h"


@interface WLArticleBlock ()


- (void)setDescriptionText:(NSString *)text;
- (void)setImages:(NSArray *)imageList;
- (void)tapOnImage:(UITapGestureRecognizer *)sender;

@property (nonatomic, strong) NSMutableArray *loadedImages;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end


@implementation WLArticleBlock


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    self.lblFirstColumn.font = [WLFontManager sharedManager].palatinoRegular20;
    self.lblTitle.font = [WLFontManager sharedManager].bebasRegular36;
    self.lblSubtitle.font = [WLFontManager sharedManager].palatinoRegular17;
    self.scrollImages.pagingEnabled = YES;
    self.loadedImages = [[NSMutableArray alloc] init];
    self.imageViews = [[NSMutableArray alloc] init];
}


- (void)setDescriptionText:(NSString *)text {

    if ([text length] > 0) {
        CGFloat lblWidth;
        if (UIInterfaceOrientationIsLandscape([[[[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation])) {
            lblWidth = 944;
        }
        else {
            lblWidth = 688;
        }

        CGSize firstSize = [text boundingRectWithSize:CGSizeMake(lblWidth / 2 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lblFirstColumn.font} context:nil].size;


        self.lblFirstColumn.text = text;
        [self.lblFirstColumn setFrame:CGRectMake(self.lblFirstColumn.frame.origin.x, self.lblFirstColumn.frame.origin.y, self.lblFirstColumn.frame.size.width, firstSize.height / 2)];
        [self.textLayer setFrame:CGRectMake(0, self.scrollImages.frame.size.height, self.frame.size.width, self.lblFirstColumn.frame.origin.y + firstSize.height / 2 + 40)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textLayer.frame.origin.y + self.textLayer.frame.size.height)];
    }
    else {
        self.lblFirstColumn.text = @"";
    }
}


- (void)setImages:(NSArray *)imageList {
    [self.textLayer setFrame:CGRectMake(0, self.scrollImages.frame.size.height, self.textLayer.frame.size.width, self.textLayer.frame.size.height)];
    for (NSString *imagePath in imageList) {
        UIImage *image = [[WLDataManager sharedManager] imageWithPath:imagePath];
        [self.loadedImages addObject:image];

        WLImageView *imageView = [[WLImageView alloc] initWithImage:image];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        imageView.imagePath = imagePath;


        [self.imageViews addObject:imageView];
        [self.scrollImages addSubview:imageView];
    }

    [self layout];
}


- (void)setLayoutWithTextBlock:(WLTextBlock *)textBlock {
    [self setImages:textBlock.blockImagesPath];
    [self setDescriptionText:textBlock.blockText];
    self.lblTitle.text = textBlock.blockTitle;
    self.lblSubtitle.text = textBlock.blockSubtitle;
}


- (void)tapOnImage:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapOnImageWithPath:imageContainer:)]) {
            WLImageView *imageView = (WLImageView *) sender.view;
            [self.delegate tapOnImageWithPath:imageView.imagePath imageContainer:imageView];
        }
    }
}

- (void)layout {
    CGFloat screenScale = [[UIScreen mainScreen] isRetinaDisplay] ? 2.0f : 1.0f;

    self.textLayer.frame = CGRectMake(0, self.scrollImages.frame.size.height, self.textLayer.frame.size.width, self.textLayer.frame.size.height);

    CGFloat x = 0;
    CGFloat y = 0;
    for (NSUInteger i = 0; i < [self.loadedImages count]; i++) {
        UIImage *image = self.loadedImages[i];
        UIImageView *imageView = self.imageViews[i];
        
        NSLog(@"layout %@ %@", image, NSStringFromCGSize(image.size));
        y = image.size.height / screenScale;


        imageView.contentMode = UIViewContentModeScaleAspectFill;
        if (UIInterfaceOrientationIsLandscape([[[[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation])) {
            [imageView setFrame:CGRectMake(x, 0, image.size.width / screenScale, image.size.height / screenScale)];
        }
        else {
            [imageView setFrame:CGRectMake(x, 0, image.size.width * 0.75 / screenScale, image.size.height * 0.75 / screenScale)];
        }

        x += imageView.frame.size.width;
    }
    if (UIInterfaceOrientationIsLandscape([[[[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation])) {
        [self.scrollImages setFrame:CGRectMake(0, 0, self.scrollImages.frame.size.width, y)];
    }
    else {
        [self.scrollImages setFrame:CGRectMake(0, 0, self.scrollImages.frame.size.width, y * 0.75)];
    }
    [self.scrollImages setContentSize:CGSizeMake(x, self.scrollImages.frame.size.height)];


    if ([self.lblFirstColumn.text length] > 0) {
        CGFloat lblWidth;
        if (UIInterfaceOrientationIsLandscape([[[[[UIApplication sharedApplication] delegate] window] rootViewController] interfaceOrientation])) {
            lblWidth = 944;
        }
        else {
            lblWidth = 688;
        }

        CGSize firstSize = [self.lblFirstColumn.text boundingRectWithSize:CGSizeMake(lblWidth / 2 - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lblFirstColumn.font} context:nil].size;

        [self.lblFirstColumn setFrame:CGRectMake(self.lblFirstColumn.frame.origin.x, self.lblFirstColumn.frame.origin.y, self.lblFirstColumn.frame.size.width, firstSize.height / 2)];
        [self.textLayer setFrame:CGRectMake(0, self.scrollImages.frame.size.height, self.frame.size.width, self.lblFirstColumn.frame.origin.y + firstSize.height / 2 + 40)];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textLayer.frame.origin.y + self.textLayer.frame.size.height)];
    }
}


@end
