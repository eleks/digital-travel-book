//
//  WLPointBlockViewSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLPointBlockViewSw: UIView, UIPopoverControllerDelegate {

    // Outlets
    @IBOutlet weak var imgMain:UIImageView
    @IBOutlet weak var lblFirst:UILabel
    @IBOutlet weak var textView:UIView
    
    var popover:UIPopoverController? = nil
    var currentBlock:WLPointBlock? = nil
    
    var pointShowing:Bool = false
    
    var imgBtnNormal:UIImage?       = nil
    var imgBtnHighlighted:UIImage?  = nil
    var imgBtnSelected:UIImage?     = nil
    
    // Instance methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        imgBtnNormal = UIImage(named: "btnPointNormal.png")
        imgBtnHighlighted = UIImage(named: "btnPointHightlight.png")
        imgBtnSelected = UIImage(named: "btnPointSelected.png")
        self.lblFirst.font = WLFontManager.sharedManager.palatinoRegular20
        pointShowing = false
        NSNotificationCenter.defaultCenter()!.addObserver(self, selector:Selector("willRotate:"), name:kRotateNotification, object:nil)
        NSNotificationCenter.defaultCenter()!.addObserver(self, selector:Selector("dissmiss"), name:"Toggled drawer", object:nil)
    }
    
    // .. Keyboard notification
    func setLayoutWithPointBlock(pointBlock: WLPointBlock)
    {
        self.currentBlock = pointBlock
        self.layout()
    }
    
    func dismissPopover()
    {
        if self.popover {
            self.popover!.dismissPopoverAnimated(true)
        }
        
        self.popover = nil
        for i:Int in 0..self.currentBlock!.blockPoints.count {
            var btn:UIButton? = (self.viewWithTag(100 + i)) as? UIButton
            if let btn_ = btn? {
                btn_.selected = false
            }
        }
        pointShowing = false
    }
    
    func willRotate(notification:NSNotification)
    {
        if let popover_ = self.popover? {
            
            popover_.dismissPopoverAnimated(true)
            self.popover = nil
            
            for i:Int in 0..self.currentBlock!.blockPoints.count {
                var btn:UIButton? = (self.viewWithTag(100 + i)) as? UIButton
                if let btn_ = btn? {
                    btn_.selected = false
                }
            }
        }
        pointShowing = false
    }
    
    func btnTouch(sender:UIButton)
    {
        if !pointShowing {
            pointShowing = true
    
            var viewController = UIViewController()
            
            if viewController.mm_drawerController!.openSide != MMDrawerSide.None {
                viewController.mm_drawerController!.toggleDrawerSide(MMDrawerSide.None, animated:true, completion:nil)
            }
    
            for i:Int in 0..self.currentBlock!.blockPoints.count {
                var btn:UIButton? = (self.viewWithTag(100 + i)) as? UIButton
                if let btn_ = btn? {
                    btn_.selected = (btn_.tag == sender.tag)
                }
            }
            let point:WLPoint = (self.currentBlock!.blockPoints)[(sender.tag - 100) as Int]
            let pointVC:WLPointVCSw = WLPointVCSw(nibName: "WLPointVCSw", bundle: nil)
    
            self.popover = UIPopoverController(contentViewController: pointVC)
            self.popover!.delegate = self
            pointVC.setDetailWithPoint(point)
            self.popover!.popoverContentSize = pointVC.view.frame.size
            self.popover!.presentPopoverFromRect(sender.frame, inView:self, permittedArrowDirections:UIPopoverArrowDirection.Any, animated:true)
        }
    }
    
    func dissmiss()
    {
        self.dismissPopover()
    }
    
    func popoverControllerShouldDismissPopover(popoverController:UIPopoverController) -> Bool
    {
        for i:Int in 0..self.currentBlock!.blockPoints.count {
            var btn:UIButton? = (self.viewWithTag(100 + i)) as? UIButton
            if let btn_ = btn? {
                btn_.selected = false
            }
        }
        return true
    }
    
    
    func popoverControllerDidDismissPopover(popoverController:UIPopoverController)
    {
        pointShowing = false
        self.popover = nil
    }
    
    func setDescriptionText(text:String)
    {
        if (text.bridgeToObjectiveC().length > 0) {
            var lblWidth:CGFloat
            if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication()!.delegate!.window!.rootViewController!.interfaceOrientation)) {
                lblWidth = 944
            }
            else {
                lblWidth = 688
            }

            let firstSize:CGSize = text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(lblWidth / 2 - 40, CGFloat(MAXFLOAT)),
                                                                                    options:NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                                                    attributes:[NSFontAttributeName : self.lblFirst.font],
                                                                                    context:nil).size
            self.lblFirst.text = text
            self.lblFirst.frame = CGRectMake(self.lblFirst.frame.origin.x, self.lblFirst.frame.origin.y, self.lblFirst.frame.size.width, firstSize.height / 2)
            self.textView.frame = CGRectMake(0, self.imgMain.frame.size.height + 20, self.frame.size.width, self.lblFirst.frame.origin.y + firstSize.height / 2 + 40)
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.textView.frame.origin.y + self.textView.frame.size.height)
        }
        else {
            self.lblFirst.text = ""
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter()!.removeObserver(self)
    }
    
    func layout()
    {
        let img:UIImage = WLDataManager.sharedManager.imageWithPath(self.currentBlock!.blockImagePath)
        self.imgMain.image = img
        
        if UIScreen.mainScreen()!.isRetinaDisplay() {
            if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication()!.delegate!.window!.rootViewController!.interfaceOrientation) {
                self.imgMain.frame = CGRectMake(0, 0, self.imgMain.frame.size.width, img.size.height / 2)
            }
            else {
                self.imgMain.frame = CGRectMake(0, 0, self.imgMain.frame.size.width, img.size.height * 0.75 / 2)
            }
    
        }
        else if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication()!.delegate!.window!.rootViewController!.interfaceOrientation) {
            self.imgMain.frame = CGRectMake(0, 0, self.imgMain.frame.size.width, img.size.height)
        }
        else {
            self.imgMain.frame = CGRectMake(0, 0, self.imgMain.frame.size.width, img.size.height * 0.75)
        }
    
        self.setDescriptionText(self.currentBlock!.blockText)
        
        for i:Int in 0..self.currentBlock!.blockPoints.count {
            var point:WLPoint = (self.currentBlock!.blockPoints)[i]
            var btn:UIButton? = (self.viewWithTag(100 + i)) as? UIButton
            
            if let button_ = btn? {
            }
            else{
                btn = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
                btn!.setBackgroundImage(imgBtnNormal, forState:UIControlState.Normal)
                btn!.setBackgroundImage(imgBtnHighlighted, forState:UIControlState.Highlighted)
                btn!.setBackgroundImage(imgBtnSelected, forState:UIControlState.Selected)
                btn!.addTarget(self, action:Selector("btnTouch:"), forControlEvents:UIControlEvents.TouchUpInside)
                btn!.tag = 100 + i
                self.addSubview(btn)
            }
            if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication()!.delegate!.window!.rootViewController!.interfaceOrientation) {
                btn!.frame = CGRectMake(point.x / 2, point.y / 2, 50, 50)
            }
            else {
                btn!.frame = CGRectMake(point.x / 2 * 0.75, point.y / 2 * 0.75, 50, 50)
            }
    
        }
    }
    
}




