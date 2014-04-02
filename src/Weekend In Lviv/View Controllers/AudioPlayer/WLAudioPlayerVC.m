//
//  WLAudioPlayerVC.m
//  Weekend In Lviv
//
//  Created by Viktor Malieichyk on 3/18/14.
//  Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import "WLAudioPlayerVC.h"

@interface WLAudioPlayerVC ()

@property (nonatomic) BOOL playing;
@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation WLAudioPlayerVC


static WLAudioPlayerVC *playerVC = nil;


+ (WLAudioPlayerVC *)playerVC {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        playerVC = [[WLAudioPlayerVC alloc] initWithNibName:@"WLAudioPlayerVC" bundle:nil];
    });

    return playerVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.playing = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAudioFile:) name:@"playAudioFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePlayer) name:@"HidePlayer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlayer) name:@"ShowPlayer" object:nil];

    [[UIToolbar appearance] setBarTintColor:RGB(48, 23, 0)];

    [self updateTime:nil];
    [self hide:YES];
}


- (void)hidePlayer {
    [self hide:YES];
}


- (void)showPlayer {
    [self hide:NO];
}


- (void)hide:(BOOL)hide {
    if (hide) {
        for (UIBarButtonItem *item in self.toolbar.items) {
            if (!item.customView) {
                item.customView = [[UIView alloc] init];
                item.customView.tag = 1;
            }
            item.customView.hidden = YES;
        }
    }
    else {
        for (UIBarButtonItem *item in self.toolbar.items) {
            if (item.customView.tag == 1) {
                item.customView = nil;
            }
            item.customView.hidden = NO;
        }
    }
}


- (void)playerPlaybackDidFinish:(NSNotification *)notification {
    self.playing = NO;
    self.player.currentPlaybackTime = 0;
    self.progressbar.value = 0;
    self.progressbar.maximumValue = 0;
    [self.updateTimer invalidate];
    [self updateTime:nil];
}


- (void)playAudioFile:(NSNotification *)notification {
    if (self.playing) {
        [self pause];
    }
    self.audioName = notification.userInfo[@"file"];

    if (self.audioName) {
        [self play];
    }
    else {
        [self pause];
    }
}


- (void)playCurrentAudioFile {
    if (self.audioName) {
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:self.audioName]];

        [self hide:NO];

        self.progressbar.value = (float) self.player.currentPlaybackTime;
        self.progressbar.maximumValue = (float) self.player.duration;
    }
    else {
        [self hide:YES];
    }
}


- (void)setPlaying:(BOOL)playing {

    if (playing) {
        self.itemPlay.image = [UIImage imageNamed:@"pause_icon"];
    }
    else {
        self.itemPlay.image = [UIImage imageNamed:@"play_icon"];
    }
    _playing = playing;
}

- (IBAction)changeProgress:(id)sender {
    self.player.currentPlaybackTime = self.progressbar.value;
    [self updateTime:nil];
}


- (IBAction)btnPlayTouch:(id)sender {
    NSLog(@"btnPlayTouch");
    if (self.playing) {

        [self pause];
    }
    else {
        [self play];
    }
}


- (void)updateTime:(NSTimer *)timer {
    if (self.progressbar.value > (float) self.player.currentPlaybackTime) {
        return;
    }
    self.progressbar.value = (float) self.player.currentPlaybackTime;
    self.progressbar.maximumValue = (float) self.player.duration;

    self.lblTimeElapsed.text = [self minutesAndSecondsFromNSTimeInterval:self.player.currentPlaybackTime];
    self.lblTimeRemaining.text = [self minutesAndSecondsFromNSTimeInterval:self.player.duration - self.player.currentPlaybackTime];
}


- (void)pause {
    [self.updateTimer invalidate];
    [self.player pause];
    self.playing = NO;
}


- (void)play {
    if ([self.audioName length] == 0) {
        return;
    }

    if(self.player.currentPlaybackTime == 0 || isnan(self.player.currentPlaybackTime)) {
        [self playCurrentAudioFile];
        [self.player prepareToPlay];
    }

    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
    [self.player play];
    self.playing = YES;
}


- (NSString *)minutesAndSecondsFromNSTimeInterval:(NSTimeInterval)time {
    NSUInteger minutes = MIN((NSUInteger)time / 60, 99);
    NSUInteger seconds = (NSUInteger)time % 60;

    return [NSString stringWithFormat:@" %lu:%02lu", (unsigned long)minutes, (unsigned long)seconds];
}

@end
