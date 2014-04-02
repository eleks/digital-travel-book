//
//  WLPhotoGalleryVC.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/14/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WLPhotoGalleryVC : UIViewController <UIScrollViewDelegate, UIPageViewControllerDataSource>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollImages;
@property (weak, nonatomic) IBOutlet UILabel *lblSwipe;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) NSArray *imagePathList;
@property (nonatomic) NSUInteger selectedImageIndex;


- (IBAction)btnCloseTouch:(id)sender;


@end
