//
//  WLMenuButton.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLMenuButton: UIBarButtonItem {
   
    // Designited initializer
    init(target:AnyObject, action:Selector)
    {
        var buttonBackground:UIImage = UIImage(named: "BtnMenuBkg")
        var buttonView:UIButton = UIButton(frame: CGRectMake(0, 0, buttonBackground.size.width, buttonBackground.size.height))
        
        super.init()
        
        buttonView.addTarget(self, action: Selector("touchUpInside:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.customView = buttonView
        self.action = action
        self.target = target
        
        buttonView .setBackgroundImage(buttonBackground, forState: UIControlState.Normal)
    }

    func touchUpInside(sender:AnyObject)
    {
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: self.action, userInfo: nil, repeats: false)
        //replaced => self.target.performSelector(self.action, withObject: sender)
    }

    // Class method
    class func drawerButtonItemImage() -> UIImage
    {
        return UIImage(named: "BtnMenuBkg")
    }
    
}
