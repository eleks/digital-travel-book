//
//  WLAudioPlayerVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit
import MediaPlayer

// Singleton shared instance of class
let _singletonPlayerVCSharedInstance:WLAudioPlayerVCSw = WLAudioPlayerVCSw.init(nibName: "WLAudioPlayerVCSw", bundle: nil)

class WLAudioPlayerVCSw: UIViewController {

    // Outlets
    @IBOutlet weak var progressbar:UISlider
    @IBOutlet weak var lblTimeElapsed:UILabel
    @IBOutlet weak var lblTimeRemaining:UILabel
    @IBOutlet weak var itemPlay:UIBarButtonItem
    @IBOutlet var toolbar:UIToolbar
    
    // Instance variables
    var audioName:String? = nil
    var _playing:Bool = false
    
    var playing:Bool {
        get {
            return _playing
        }
        set (playing) {
            if playing {
                self.itemPlay.image = UIImage(named:"pause_icon")
            }
            else {
                self.itemPlay.image = UIImage(named:"play_icon")
            }
            _playing = playing
        }
    }
    var player:MPMoviePlayerController? = nil
    var updateTimer:NSTimer? = nil
    
    
    
    // Class variable
    class var playerVC:WLAudioPlayerVCSw
    {
        return _singletonPlayerVCSharedInstance
    }

    
    // Override methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.playing = false
        
        NSNotificationCenter.defaultCenter()!.addObserver(self, selector: Selector("playAudioFile:"), name: "playAudioFile", object: nil)
        NSNotificationCenter.defaultCenter()!.addObserver(self, selector: Selector("playerPlaybackDidFinish:"), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        
        NSNotificationCenter.defaultCenter()!.addObserver(self, selector: Selector("hidePlayer"), name: "HidePlayer", object: nil)
        NSNotificationCenter.defaultCenter()!.addObserver(self, selector: Selector("showPlayer"), name: "ShowPlayer", object: nil)
        
        UIToolbar.appearance()!.barTintColor = RGB(48, 23, 0)
        
        self.updateTime(nil)
        self.hide(true)
    }
    
    
    
    // Instance methods
    func hidePlayer()
    {
        self.hide(true)
    }
    
    func showPlayer()
    {
        self.hide(false)
    }
    
    func hide(hide:Bool)
    {
        if hide {
            for item in self.toolbar.items as UIBarButtonItem[] {
                if (!item.customView) {
                    item.customView = UIView()
                    item.customView.tag = 1
                }
                item.customView.hidden = true
            }
        }
        else {
            for item:UIBarButtonItem in self.toolbar.items as UIBarButtonItem[] {
                
                if item.customView {
                    if (item.customView.tag == 1) {
                        item.customView = nil
                    }
                }
                
                if item.customView {
                    item.customView.hidden = false
                }
            }
        }
    }
    
    func updateTime(timer:NSTimer?)
    {
        if let player_ = self.player? {
            
            if self.progressbar!.value > Float(player_.currentPlaybackTime) {
                return;
            }
            self.progressbar!.value = Float(player_.currentPlaybackTime)
            self.progressbar!.maximumValue = Float(player_.duration)
            
            self.lblTimeElapsed.text = self.minutesAndSecondsFromNSTimeInterval(player_.currentPlaybackTime)
            self.lblTimeRemaining.text = self.minutesAndSecondsFromNSTimeInterval(player_.duration - player_.currentPlaybackTime)
        }
    }
    
    
    func pause()
    {
        self.updateTimer!.invalidate()
        self.player!.pause()
        self.playing = false
    }
    
    
    func play()
    {
        if self.audioName!.bridgeToObjectiveC().length == 0 {
            return;
        }

        if let player_ = self.player? {
            
            if (player_.currentPlaybackTime == 0 ||
                (player_.currentPlaybackTime).isNaN){
                    self.playCurrentAudioFile()
                    player_.prepareToPlay()
            }
        }
        else{
            self.playCurrentAudioFile()
            self.player!.prepareToPlay()
        }
        
        
    
        self.updateTimer = NSTimer( timeInterval:NSTimeInterval(1.0),
                                    target:self,
                                    selector:Selector("updateTime:"),
                                    userInfo:nil,
                                    repeats:true)
        NSRunLoop.currentRunLoop()!.addTimer(self.updateTimer, forMode:NSRunLoopCommonModes)
        self.player!.play()
        self.playing = true
    }
    
    func minutesAndSecondsFromNSTimeInterval(time:NSTimeInterval) -> String
    {
        var minutes:UInt = 0
        var time_ = abs(time)
        if !time_.isNaN {
            
            minutes = min(UInt(time_ / 60), 99)
        }
        let seconds = UInt(time_ % 60)
    
        return String(format:" %lu:%02lu", CUnsignedLong(minutes), CUnsignedLong(seconds))
    }
    
    func playerPlaybackDidFinish(notification:NSNotification)
    {
        self.playing = false
        self.player!.currentPlaybackTime = 0
        self.progressbar!.value = 0
        self.progressbar!.maximumValue = 0
        self.updateTimer!.invalidate()
        self.updateTime(nil)
    }
    
    
    func playAudioFile(notification:NSNotification)
    {
        if (self.playing) {
            self.pause()
        }
        self.audioName = notification.userInfo["file"] as? String
    
        if (self.audioName) {
            self.play()
        }
        else {
            self.pause()
        }
    }
    
    func playCurrentAudioFile()
    {
        if let audioName_ = self.audioName? {
            self.player = MPMoviePlayerController(contentURL:NSURL(fileURLWithPath:audioName_))
    
            self.hide(false)
    
            self.progressbar!.value = Float(self.player!.currentPlaybackTime)
            self.progressbar!.maximumValue = Float(self.player!.duration)
        }
        else {
            self.hide(true)
        }
    }
    
    // Actions
    @IBAction func changeProgress(sender:AnyObject)
    {
        self.player!.currentPlaybackTime = NSTimeInterval(self.progressbar!.value)
        self.updateTime(nil)
    }
    
    @IBAction func btnPlayTouch(sender:AnyObject)
    {
        println("btnPlayTouch")
        
        if self.playing {
            self.pause()
        }
        else {
            self.play()
        }
    }
    
}




