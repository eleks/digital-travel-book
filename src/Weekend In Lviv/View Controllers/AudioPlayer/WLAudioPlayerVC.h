//
//  WLAudioPlayerVC.h
//  Weekend In Lviv
//
//  Created by Viktor Malieichyk on 3/18/14.
//  Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLAudioPlayerVC : UIViewController


@property (weak, nonatomic) IBOutlet UISlider *progressbar;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeElapsed;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeRemaining;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemPlay;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) NSString *audioName;

- (IBAction)changeProgress:(id)sender;
- (IBAction)btnPlayTouch:(id)sender;

+ (WLAudioPlayerVC *)playerVC;

@end
