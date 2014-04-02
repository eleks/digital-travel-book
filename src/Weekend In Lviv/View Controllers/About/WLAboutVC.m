//
//  WLAboutVC.m
//  Weekend In Lviv
//
//  Created by Viktor Malieichyk on 3/19/14.
//  Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import "WLAboutVC.h"
#import "WLAudioPlayerVC.h"
#import "NSArray+ReverseOrder.h"
#import "WLMenuButton.h"
#import "UIViewController+MMDrawerController.h"
#import "WLFontManager.h"


static NSUInteger padding = 20;


@interface WLAboutVC ()

@end


@implementation WLAboutVC


- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.delegate = self;

    WLAudioPlayerVC *playerVC = [WLAudioPlayerVC playerVC];
    [playerVC.view removeFromSuperview];
    self.navigationItem.rightBarButtonItems = [playerVC.toolbar.items reversedArray];

    WLMenuButton *leftDrawerButton = [[WLMenuButton alloc] initWithTarget:self action:@selector(btnMenuTouch:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    self.lblTitle.text = @"Über ELEKS";
    NSURL *aboutURL = [[NSBundle mainBundle] URLForResource:@"about" withExtension:@"html"];
    NSString *aboutText = [NSString stringWithContentsOfURL:aboutURL encoding:NSUTF8StringEncoding error:nil];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.scrollView.bounces = NO;

    [self.webView loadHTMLString:aboutText baseURL:nil];

    self.lblTitle.font = [WLFontManager sharedManager].bebasRegular36;
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutViews];
}


- (void)layoutViews {
    CGRect newFrame = self.view.frame;

    CGRect imgAboutFrame = self.imgAbout.frame;
    imgAboutFrame.size.height *= newFrame.size.width / imgAboutFrame.size.width;
    imgAboutFrame.size.width = newFrame.size.width;
    self.imgAbout.frame = imgAboutFrame;

    CGRect imgDemoFrame = self.imgDemo.frame;
    imgDemoFrame.origin.x = newFrame.size.width - imgDemoFrame.size.width;
    imgDemoFrame.origin.y = 0;
    self.imgDemo.frame = imgDemoFrame;

    self.lblTitle.frame = CGRectMake(padding, CGRectGetMaxY(imgAboutFrame) + padding, newFrame.size.width - padding * 2, self.lblTitle.frame.size.height);

    CGSize webViewPreferredSize = [self.webView sizeThatFits:CGSizeZero];
    self.webView.frame = CGRectMake(padding, CGRectGetMaxY(self.lblTitle.frame), newFrame.size.width - padding * 2, MAX(webViewPreferredSize.height, newFrame.size.height - CGRectGetMaxY(self.lblTitle.frame) - padding * 2));

    self.scrollView.contentSize = CGSizeMake(newFrame.size.width, CGRectGetMaxY(self.webView.frame));
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self layoutViews];
}


- (void)btnMenuTouch:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGSize webViewPreferredSize = [self.webView sizeThatFits:CGSizeZero];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x, CGRectGetMaxY(self.lblTitle.frame), self.webView.frame.size.width, webViewPreferredSize.height);

    self.scrollView.contentSize = CGSizeMake(self.webView.frame.size.width, CGRectGetMaxY(self.webView.frame));
}

@end
