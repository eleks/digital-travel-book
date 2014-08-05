//
//  WLTimelineSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLTimelineSw: UIViewController, UIScrollViewDelegate, WLTimelineImageViewSwDelegate {

    // Outlets
    @IBOutlet weak var scrollTimeline:UIScrollView
    @IBOutlet weak var viewCentury:UIView
    @IBOutlet weak var imgBottom:UIImageView
    @IBOutlet weak var imgArrow:UIImageView
    @IBOutlet weak var viewTimelinePoints:UIView
    
    @IBOutlet weak var btnFurstenhalter:UIButton
    @IBOutlet weak var btnExpansion:UIButton
    @IBOutlet weak var btnBefreiungskampf:UIButton
    @IBOutlet weak var btnNeueGeschitchte:UIButton
    
    @IBOutlet weak var navigationView:UIView
    
    
    // Instance variables
    var topView:WLTopTimelineViewSw? = nil
    
    var oldFrame  = CGRect(x: 0, y: 0, width: 0, height: 0)
    var oldOffset = CGPoint(x: 0, y: 0)
    
    
    // Instance methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftDrawerButton = WLMenuButton(target: self, action: Selector("btnMenuTouch:"))
        self.navigationItem!.setLeftBarButtonItem(leftDrawerButton, animated:true)
        
        var playerVC:WLAudioPlayerVCSw = WLAudioPlayerVCSw.playerVC
        playerVC.view!.removeFromSuperview()
        self.navigationItem!.rightBarButtonItems = playerVC.toolbar!.items!.reverse()
        
        let panOnPoints = UIPanGestureRecognizer(target: self, action: Selector("panOnPoints:"))
        self.imgBottom!.addGestureRecognizer(panOnPoints)
        
        var tap = UITapGestureRecognizer(target: self, action: Selector("tapOnPoints:"))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.imgBottom!.addGestureRecognizer(tap)
        
        self.topView = NSBundle.mainBundle()!.loadNibNamed("WLTopTimelineViewSw", owner:nil, options:nil)[0] as? WLTopTimelineViewSw
        
        self.topView!.frame = CGRectMake(0, 0, self.topView!.frame.size.width, 500)
        
        for i:Int in 501...525 {
            let imgView = (self.viewTimelinePoints!.viewWithTag(i)) as WLTimelineImageViewSw
            imgView.delegate = self
        }
        
        self.scrollTimeline!.addSubview(self.topView)
        
        self.oldFrame = CGRectMake(0, 0, 768, 1024);
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        for i:Int in 101...104 {
            var lblView = self.viewCentury!.viewWithTag(i) as UILabel
            lblView.font = WLFontManager.sharedManager.bebasRegular20
            lblView.textColor = RGB(161, 106, 46)
            
            var btnView = self.viewCentury!.viewWithTag(i * 2) as UIButton
            btnView.titleLabel.font = WLFontManager.sharedManager.bebasRegular20
            btnView.setTitleColor(RGB(161, 106, 46), forState: UIControlState.Normal)
        }
        
        self.setupScrollLayer()
        self.setBottomImage()
        self.setArrowPositionOnScrollView()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        self.setBottomImage()
        self.setupScrollLayer()
        
        self.setArrowPositionOnScrollView()
    }
    
    func btnMenuTouch(sender:AnyObject)
    {
        self.mm_drawerController!.toggleDrawerSide(MMDrawerSide.Left, animated:true, completion:nil)
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        self.oldFrame  = self.view.frame
        self.oldOffset = self.scrollTimeline.contentOffset
    }
    
    func setupScrollLayer()
    {
        let viewFrame:CGRect = self.view.frame
        self.scrollTimeline.contentSize = self.topView!.frame.size
    
        self.viewCentury.frame = CGRectMake(0,
                                            viewFrame.size.height - self.viewCentury.frame.size.height,
                                            viewFrame.size.width,
                                            self.viewCentury.frame.size.height)
        self.navigationView.frame = CGRectMake(0,
                                               self.viewCentury.frame.origin.y - self.navigationView.frame.size.height,
                                               viewFrame.size.width,
                                               self.navigationView.frame.size.height);
        self.scrollTimeline.frame = CGRectMake(0,
                                               64,
                                               viewFrame.size.width,
                                               self.navigationView.frame.origin.y)
        let scale:CGFloat = self.topView!.frame.size.height / self.navigationView.frame.origin.y
        self.topView!.setHeight(self.navigationView.frame.origin.y)
        self.scrollTimeline.contentSize     = self.topView!.frame.size
        self.scrollTimeline.contentOffset   = CGPointMake(min(max(((self.oldOffset.x + self.oldFrame.size.width / 2) / scale - self.view.frame.size.width / 2), 0), self.scrollTimeline.contentSize.width - self.scrollTimeline.frame.size.width), 0)
    
        var previousX = CGFloat(0)
        let screenScale = CGFloat(self.oldFrame.size.width / self.view.frame.size.width)
        
        for tag:Int in 101...104 {
            
            let lblView = self.viewCentury!.viewWithTag(tag) as UIView
            let btnView = self.viewCentury!.viewWithTag(tag * 2) as UIView
            var frame:CGRect = lblView.frame
            
            frame.origin.x   = previousX
            frame.size.width /= screenScale
            lblView.frame    = frame
            previousX        = CGRectGetMaxX(frame)
            btnView.frame    = frame
        }
    }
    
    func setBottomImage()
    {
        self.imgBottom!.image = UIImage(named: "TimelineBottomBkg.png")
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView)
    {
        let delta = CGFloat(scrollView.contentSize.width - scrollView.bounds.size.width) / (self.imgBottom.frame.size.width - 18)
        self.imgArrow.frame = CGRectMake(scrollView.contentOffset.x / delta - 11,
                                         self.imgArrow.frame.origin.y,
                                         self.imgArrow.frame.size.width,
                                         self.imgArrow.frame.size.height)
    
        self.setArrowPositionOnScrollView()
    }
    
    
    func setArrowPositionOnScrollView()
    {
        let currentPoint = CGPointMake(CGRectGetMidX(self.imgArrow.frame), CGRectGetMaxY(self.imgArrow.frame));
        let viewTimelinePoint:CGPoint = self.viewTimelinePoints!.convertPoint(currentPoint, fromView:self.navigationView)
    
        for tag:Int in 501...525 {
            let imgView = self.viewTimelinePoints!.viewWithTag(tag) as WLTimelineImageViewSw
    
            if CGRectGetMinX(imgView.frame) <= viewTimelinePoint.x &&
               CGRectGetMaxX(imgView.frame) >= viewTimelinePoint.x {
                    
                var activeImgView = self.viewTimelinePoints!.viewWithTag(tag) as WLTimelineImageViewSw
                activeImgView.becomeFirstResponder()
                break;
            }
        }
    
        let currentPointLbl = CGPointMake(self.imgArrow.frame.origin.x + self.imgArrow.frame.size.width / 2, 60);
        
        for var tag:Int=101; tag<=104; tag++ {
            
            var lbl = self.viewCentury!.viewWithTag(tag) as UILabel
            var btn = self.viewCentury!.viewWithTag(tag * 2) as UIButton
            
            if (CGRectGetMinX(lbl.frame) < currentPointLbl.x &&
                CGRectGetMaxX(lbl.frame) > currentPointLbl.x) {
                
                lbl.textColor = RGB(255, 247, 231)
                btn.setTitleColor(RGB(255, 247, 231), forState: UIControlState.Normal)
                
                for ; ++tag <= 104; tag++ {
                    (self.viewCentury!.viewWithTag(tag) as UILabel).textColor = RGB(161, 106, 46)
                    (self.viewCentury!.viewWithTag(tag * 2) as UIButton).setTitleColor(RGB(161, 106, 46), forState:UIControlState.Normal)
                }
                break
            }
            else {
                lbl.textColor = RGB(161, 106, 46)
                btn.setTitleColor(RGB(161, 106, 46), forState:UIControlState.Normal)
            }
        }
        
    }
    
    
    func imageViewDidTouch(imageView:WLTimelineImageViewSw)
    {
        let delta = CGFloat(self.scrollTimeline.contentSize.width - self.scrollTimeline.bounds.size.width) / (self.imgBottom.frame.size.width - 18)
    
        let newRect:CGRect = CGRectMake((imageView.frame.origin.x + imageView.frame.size.width / 2 - 11) * delta,
                                         self.scrollTimeline.bounds.origin.y,
                                         self.scrollTimeline.bounds.size.width,
                                         self.scrollTimeline.bounds.size.height)
    
        self.scrollTimeline!.scrollRectToVisible(newRect, animated:true)
    }
    
    
    func panOnPoints(sender:UIPanGestureRecognizer)
    {
        if sender.numberOfTouches() == 1 {
            
            let delta = CGFloat(self.scrollTimeline.contentSize.width - self.scrollTimeline.bounds.size.width) / (self.imgBottom.frame.size.width - 18);
            let location:CGPoint = sender.locationInView(self.imgBottom!)
            let newRect = CGRectMake(location.x * delta - self.imgArrow.frame.size.width / 2,
                                     self.scrollTimeline.bounds.origin.y,
                                     self.scrollTimeline.bounds.size.width,
                                     self.scrollTimeline.bounds.size.height)
            self.scrollTimeline!.scrollRectToVisible(newRect, animated:false)
        }
    }
    
    
    func tapOnPoints(sender:UITapGestureRecognizer)
    {
        if (sender.state == UIGestureRecognizerState.Ended) {
            
            let delta = CGFloat(self.scrollTimeline.contentSize.width - self.scrollTimeline.bounds.size.width) / (self.imgBottom.frame.size.width - 18);
            let location:CGPoint = sender.locationInView(self.imgBottom)
            let newRect = CGRectMake(location.x * delta - self.imgArrow.frame.size.width / 2,
                                     self.scrollTimeline.bounds.origin.y,
                                     self.scrollTimeline.bounds.size.width,
                                     self.scrollTimeline.bounds.size.height);
            self.scrollTimeline!.scrollRectToVisible(newRect, animated:true)
        }
    }
    
    
    // Actions
    @IBAction func scrollToMiddle(sender:UIButton)
    {
        let midPoint:CGFloat = CGRectGetMidX(sender.frame)
    
        let delta = CGFloat(self.scrollTimeline.contentSize.width - self.scrollTimeline.bounds.size.width) / (self.imgBottom.frame.size.width - 18)
        let location:CGPoint = CGPointMake(midPoint, 0)
        let newRect:CGRect = CGRectMake(location.x * delta - self.imgArrow.frame.size.width / 2,
                                        self.scrollTimeline.bounds.origin.y,
                                        self.scrollTimeline.bounds.size.width,
                                        self.scrollTimeline.bounds.size.height)
        self.scrollTimeline!.scrollRectToVisible(newRect, animated:true)
    }
    
}






