//
// Created by Viktor Malieichyk on 3/17/14.
// Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import "WLMenuButton.h"


@implementation WLMenuButton

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super init];

    if (self) {
        UIImage *buttonBackground = [UIImage imageNamed:@"BtnMenuBkg"];

        UIButton * buttonView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonBackground.size.width, buttonBackground.size.height)];
        [buttonView addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        self = [self initWithCustomView:buttonView];
        if(self){
            self.customView = buttonView;
        }
        self.action = action;
        self.target = target;


//        [self setBackButtonBackgroundImage:buttonBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [buttonView setBackgroundImage:buttonBackground forState:UIControlStateNormal];

        return self;
    }

    return self;
}


-(void)touchUpInside:(id)sender{

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.action withObject:sender];
#pragma clang diagnostic pop;

}


+(UIImage*)drawerButtonItemImage{
    return [UIImage imageNamed:@"BtnMenuBkg"];
}

@end