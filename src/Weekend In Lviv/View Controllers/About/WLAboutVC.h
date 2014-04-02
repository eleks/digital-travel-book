//
//  WLAboutVC.h
//  Weekend In Lviv
//
//  Created by Viktor Malieichyk on 3/19/14.
//  Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLAboutVC : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgAbout;
@property (weak, nonatomic) IBOutlet UIImageView *imgDemo;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
