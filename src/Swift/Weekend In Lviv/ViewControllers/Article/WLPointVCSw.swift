//
//  WLPointVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLPointVCSw: UIViewController {

    // Outlets
    @IBOutlet weak var imgMain:UIImageView
    @IBOutlet weak var lblDescription:UILabel
    
    
    // Instance methods
    func setDetailWithPoint(point:WLPoint)
    {
        self.view.setNeedsDisplay()
        self.lblDescription.font = WLFontManager.sharedManager.gentiumRegular16
        let image:UIImage = WLDataManager.sharedManager.imageWithPath(point.imagePath)
        self.imgMain.image = image
        
        if UIScreen.mainScreen().isRetinaDisplay() {
            self.imgMain.frame = CGRectMake(0, 0, image.size.width / 2, image.size.height / 2)
        }
        else {
            self.imgMain.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        }
        
        let lblSize:CGSize = point.text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(self.imgMain.frame.size.width - 40,MAXFLOAT),
                                                                                  options:NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                                                  attributes:[NSFontAttributeName : self.lblDescription.font],
                                                                                  context:nil).size
        
        let lblRect = CGRectMake(20, self.imgMain.frame.size.height + 20, self.imgMain.frame.size.width - 40, lblSize.height)
        self.lblDescription.text = point.text
        self.lblDescription.frame = lblRect
        
        self.view.frame = CGRectMake(0, 0, self.imgMain.frame.size.width, self.imgMain.frame.size.height)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    
    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation:UIInterfaceOrientation) -> Bool
    {
        return true
    }


}



