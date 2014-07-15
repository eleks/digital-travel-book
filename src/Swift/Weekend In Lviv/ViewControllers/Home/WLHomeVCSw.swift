//
//  WLHomeVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit
import QuartzCore

class WLHomeVCSw: UIViewController {

    // Outlets
    @IBOutlet weak var lblMainSubtitle:UILabel
    @IBOutlet weak var lblMainTitle:UILabel
    @IBOutlet weak var imgMainTitle:UIImageView
    @IBOutlet weak var viewTimeLine:UIView
    
    @IBOutlet weak var scrollHome:UIScrollView
    
    @IBOutlet weak var imgHeaderImage:UIImageView
    
    @IBOutlet weak var viewTimelineLeft:UIView
    @IBOutlet weak var viewTimelineRight:UIView
    @IBOutlet weak var lblTimelineTop:UILabel
    @IBOutlet weak var lblTimelineTitle:UILabel
    @IBOutlet weak var lblTimelineSubtitle:UILabel
   
    @IBOutlet weak var yearPoints1642:UIImageView
    @IBOutlet weak var yearPoints1721:UIImageView
    @IBOutlet weak var yearPoints1841:UIImageView
    @IBOutlet weak var yearPointRight1867:UIImageView
    @IBOutlet weak var yearPointRight1941:UIImageView
    @IBOutlet weak var yearPointRight1992:UIImageView
    
    
    // Instance variables
    var itemViews:Dictionary<Int, WLHomeItemSw?> = Dictionary<Int, WLHomeItemSw?>()
    var detailShowing:Bool = false
    var detailVC:WLDetailVCSw? = nil
    
    let kColumnIndent = 2
    
    
    
    // Instance methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        var playerVC = WLAudioPlayerVCSw.playerVC
        playerVC.view!.removeFromSuperview()
        self.navigationItem!.rightBarButtonItems = playerVC.toolbar!.items!.reverse()
        
        var leftDrawerButton = WLMenuButton(target: self, action: Selector("btnMenuTouch"))
        self.navigationItem!.setLeftBarButtonItem(leftDrawerButton, animated:true)
    
        self.detailShowing = false
    
        self.setLabelsLayout()
        var tapOnTimeline = UITapGestureRecognizer(target: self, action: Selector("tapOnTimeline:"))
        tapOnTimeline.numberOfTapsRequired = 1
        tapOnTimeline.numberOfTouchesRequired = 1
        self.viewTimeLine!.addGestureRecognizer(tapOnTimeline)
        
        self.startAnimation()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setScrollLayout()
    }
    
    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool
    {
        return true
    }

    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        self.setScrollLayout()
    }
    
    override func viewDidLayoutSubviews()
    {
        self.setScrollLayout()
    }
    
    func setLabelsLayout()
    {
        self.lblMainTitle.font = WLFontManager.sharedManager.bebasRegular120
        self.lblMainSubtitle.font = WLFontManager.sharedManager.gentiumRegular12
    
        for i:Int in 601...603{
            var lbl = self.viewTimelineLeft!.viewWithTag(i)! as UILabel
            lbl.font = (WLFontManager.sharedManager.palatinoItalic20)
        }
    
        for i:Int in 604...606 {
            var lbl = self.viewTimelineRight!.viewWithTag(i)! as UILabel
            lbl.font = WLFontManager.sharedManager.palatinoItalic20
        }
    
        self.lblMainTitle.userInteractionEnabled = true
    }
    
    func setScrollLayout()
    {
        var columnsCount:Int
        if UIInterfaceOrientationIsPortrait(self.interfaceOrientation) {
            columnsCount = 2
            
            self.imgHeaderImage.frame = CGRectMake(0, 0, self.imgHeaderImage.frame.size.width, 329 * 0.75)
            let delta = CGFloat(329 * 0.25 / 2)
    
            self.imgMainTitle.frame     = CGRectMake(self.imgMainTitle.frame.origin.x,
                                                    65 - delta,
                                                    self.imgMainTitle.frame.size.width,
                                                    self.imgMainTitle.frame.size.height)
            self.lblMainTitle.frame     = CGRectMake(self.lblMainTitle.frame.origin.x,
                                                    126 - delta,
                                                    self.lblMainTitle.frame.size.width,
                                                    self.lblMainTitle.frame.size.height)
            self.lblMainSubtitle.frame  = CGRectMake(self.lblMainSubtitle.frame.origin.x,
                                                    102 - delta,
                                                    self.lblMainSubtitle.frame.size.width,
                                                    self.lblMainSubtitle.frame.size.height)
        }
        else {
            columnsCount = 3
            self.imgHeaderImage.frame   = CGRectMake(0,
                                                    0,
                                                    self.imgHeaderImage.frame.size.width,
                                                    329)
            self.imgMainTitle.frame     = CGRectMake(self.imgMainTitle.frame.origin.x,
                                                    65,
                                                    self.imgMainTitle.frame.size.width,
                                                    self.imgMainTitle.frame.size.height)
            self.lblMainTitle.frame     = CGRectMake(self.lblMainTitle.frame.origin.x,
                                                    126,
                                                    self.lblMainTitle.frame.size.width,
                                                    self.lblMainTitle.frame.size.height)
            self.lblMainSubtitle.frame  = CGRectMake(self.lblMainSubtitle.frame.origin.x,
                                                    102,
                                                    self.lblMainSubtitle.frame.size.width,
                                                    self.lblMainSubtitle.frame.size.height)
        }
        self.viewTimeLine.frame         = CGRectMake(0,
                                                    self.imgHeaderImage.frame.size.height,
                                                    self.viewTimeLine.frame.size.width,
                                                    self.viewTimeLine.frame.size.height)
        self.setTimelineLayer()
    
        let itemCount:Int = WLDataManager.sharedManager.placesList.count
    
        // Space between each thumbnail
        let thumbWidth = (self.scrollHome.frame.size.width - CGFloat(columnsCount - 1) * CGFloat(kColumnIndent)) / CGFloat(columnsCount)
        let thumbHeight = CGFloat(thumbWidth * 0.73529412)
        var x = CGFloat(0)
        var y = CGFloat(self.viewTimeLine.frame.origin.y + self.viewTimeLine.frame.size.height)
  
        for i:Int in 1...itemCount {
            var place:WLPlace = (WLDataManager.sharedManager.placesList)[i - 1]

            var itemView:WLHomeItemSw? = nil
            
            if let itemView_ = self.itemViews[i] {
                itemView = itemView_
            }
            else{
                itemView = NSBundle.mainBundle()!.loadNibNamed("WLHomeItem", owner:nil, options:nil)[0] as? WLHomeItemSw
                itemView!.imgPhoto!.image = WLDataManager.sharedManager.imageWithPath(place.listImagePath)
                self.itemViews[i] = itemView
            }
            itemView!.lblCategory!.text = "Architecture"
            itemView!.lblTitle!.text = place.title
            itemView!.frame = CGRectMake(x, y, thumbWidth, thumbHeight)
    
            var tap = UITapGestureRecognizer(target: self, action: Selector("tapOnItem:"))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            itemView!.addGestureRecognizer(tap)
    
            itemView!.tag = i
    
            self.scrollHome!.addSubview(itemView!)
            if i % columnsCount == 0 {
                y += CGFloat(kColumnIndent) + CGFloat(thumbHeight)
                x = 0
            }
            else {
                x += CGFloat(kColumnIndent) + CGFloat(thumbWidth)
            }
        }
        
        let contentWidth = CGFloat(columnsCount) * (CGFloat(kColumnIndent) + thumbWidth) - CGFloat(kColumnIndent)
        self.scrollHome.contentSize = CGSizeMake(contentWidth, y)
    }
    
    func setTimelineLayer()
    {
        self.lblTimelineTop!.font        = WLFontManager.sharedManager.palatinoRegular12
        self.lblTimelineTitle!.font      = WLFontManager.sharedManager.bebasRegular44
        self.lblTimelineSubtitle!.font   = WLFontManager.sharedManager.palatinoItalic15
        
        self.lblTimelineSubtitle!.sizeToFit()
        self.lblTimelineTitle.sizeToFit()
        self.lblTimelineTop.sizeToFit()
        
        self.lblTimelineTitle.frame     = CGRectMake((self.viewTimeLine.frame.size.width - self.lblTimelineTitle.frame.size.width) / 2,
                                                    (self.viewTimeLine.frame.size.height - self.lblTimelineTitle.frame.size.height) / 2,
                                                    self.lblTimelineTitle.frame.size.width,
                                                    self.lblTimelineTitle.frame.size.height)
        self.lblTimelineTop.frame       = CGRectMake((self.viewTimeLine.frame.size.width - self.lblTimelineTop.frame.size.width) / 2,
                                                    self.lblTimelineTitle.frame.origin.y - self.lblTimelineTop.frame.size.height,
                                                    self.lblTimelineTop.frame.size.width,
                                                    self.lblTimelineTop.frame.size.height)
        self.lblTimelineSubtitle.frame  = CGRectMake((self.viewTimeLine.frame.size.width - self.lblTimelineSubtitle.frame.size.width) / 2,
                                                    self.lblTimelineTitle.frame.origin.y + self.lblTimelineTitle.frame.size.height,
                                                    self.lblTimelineSubtitle.frame.size.width,
                                                    self.lblTimelineSubtitle.frame.size.height)
        self.viewTimelineLeft.frame     = CGRectMake(0,
                                                    0,
                                                    self.lblTimelineTitle.frame.origin.x - 20,
                                                    self.viewTimelineLeft.frame.size.height)
        self.viewTimelineRight.frame    = CGRectMake(self.lblTimelineTitle.frame.origin.x + self.lblTimelineTitle.frame.size.width + 20,
                                                    0,
                                                    self.viewTimeLine.frame.size.width - (self.lblTimelineTitle.frame.origin.x + self.lblTimelineTitle.frame.size.width + 20),
                                                    self.viewTimelineRight.frame.size.height)
    }
    
    func tapOnItem(sender:UITapGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Ended && !self.detailShowing {
            self.detailShowing = true
            self.view.userInteractionEnabled = false
            let index = UInt(sender.view.tag - 1)
            self.detailVC = WLDetailVCSw(itemIndex:index)
            self.pushControllerWithAnimation(controller: self.detailVC!, fromView:sender.view!)
        }
    }
    
    func tapOnTimeline(sender:UITapGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Ended {
            let timelineVC = WLTimelineSw(nibName:"WLTimeline", bundle:nil)
            (self.navigationController! as WLNavigationController).pushViewController(timelineVC, animated:true)
        }
    }
    
    func btnMenuTouch()
    {
        self.mm_drawerController!.toggleDrawerSide(MMDrawerSide.Left, animated:true, completion:nil)
    }
    
    func pushControllerWithAnimation(#controller:UIViewController, fromView view:UIView)
    {
        weak var weakSelf = self
    
        var transitionView = UIImageView(frame: view.frame)
        transitionView.image = (view as WLHomeItemSw).imgPhoto!.image!
        view.superview!.addSubview(transitionView)
        view.hidden = true
    
        controller.view.frame = self.view.bounds
    
        UIView.animateWithDuration(kPushAnimationDuration,
            animations: {
                
                let moveY             = CATransform3DMakeTranslation(0, 0, transitionView.frame.size.height)
                let rotateView        = CATransform3DMakeRotation(0.0174532925 * -90, 1, 0, 0)
                let finishedTransform = CATransform3DConcat(rotateView, moveY)
                transitionView.layer.transform = finishedTransform
            },
            completion: {(value: Bool) in
               
                let strongSelf = weakSelf
                let viewTransform   = transitionView.layer.transform
                let controllerScale = CATransform3DMakeScale(transitionView.frame.size.width / controller.view.frame.size.width,
                                                             transitionView.frame.size.height / controller.view.frame.size.height, 0)
                
                let controllerFinishedTransform = CATransform3DConcat(viewTransform, controllerScale)
                controller.view.layer.transform = controllerFinishedTransform
                
                let viewRect:CGRect = transitionView.convertRect(transitionView.bounds, toView: strongSelf!.view)
                let controllerRect:CGRect = controller.view.frame
                
                let controllerTransY:CGFloat = viewRect.origin.y - controllerRect.origin.y
                let controllerTransX:CGFloat = viewRect.origin.x - controllerRect.origin.x
                let controllerTranslate = CATransform3DMakeTranslation(controllerTransX, controllerTransY, 0)
                let controllerTransform = CATransform3DConcat(controller.view.layer.transform, controllerTranslate)
                
                controller.view.layer.transform = controllerTransform
                
                strongSelf!.view!.addSubview(controller.view)
                
                UIView.animateWithDuration(kPushAnimationDuration,
                    animations: {
                        
                        controller.view.layer.transform = CATransform3DIdentity
                    },
                    completion: {(value: Bool) in
                
                        (strongSelf! as WLNavigationController).navigationController!.pushViewController(controller, animated:false)
                        strongSelf!.view!.userInteractionEnabled = true
                        strongSelf!.detailShowing = false
                        view.hidden = false
                
                })
            })
    }
    
    func switchToViewControllerWithIndex(#index:UInt, animated:Bool)
    {
        if let detailVC_ = self.detailVC {
            self.navigationController!.popToViewController(detailVC_, animated:false)
            detailVC_.switchToViewControllerWithIndex(index:index, animated:animated)
        }
        else{
            self.view!.userInteractionEnabled = false
            let sender:WLHomeItemSw? = self.itemViews[Int(index)] as? WLHomeItemSw
            self.detailVC = WLDetailVCSw(itemIndex:index)
            self.pushControllerWithAnimation(controller: self.detailVC!, fromView:sender!)
        }
    }
    
    func popToRootAnimated(animated:Bool)
    {
        if self.navigationController!.viewControllers!.count > 1 {
            (self.navigationController as WLNavigationController).popToRootViewControllerAnimated(animated)
            self.detailVC = nil
        }
    }
    
    // Animation
    func startAnimation()
    {
        var delay = CGFloat(0.0)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.flashOn(self.yearPoints1642)
        });
            
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.flashOn(self.yearPointRight1867)
        });
            
        delay += CGFloat(0.8)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.flashOn(self.yearPoints1721)
            });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.flashOn(self.yearPointRight1941)
            });
        
        delay += CGFloat(0.8)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.flashOn(self.yearPoints1841)
            });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.flashOn(self.yearPointRight1992)
            });
    }
    
    func flashOff(v:UIView)
    {
        UIView.animateWithDuration(NSTimeInterval(1),
                                    delay: NSTimeInterval(0),
                                    options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                v.alpha = CGFloat(0.2) //don't animate alpha to 0, otherwise you won't be able to interact with it
            },
            completion: {(value: Bool) in
                self.flashOn(v)
        })
    }
    
    func flashOn(v:UIView)
    {
        UIView.animateWithDuration(NSTimeInterval(1),
            delay: NSTimeInterval(0),
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                v.alpha = CGFloat(1)
            },
            completion: {(value: Bool) in
                self.flashOff(v)
            })
    }
}




