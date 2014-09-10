//
//  WLTopTimelineViewSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLTopTimelineViewSw: UIView {

    // Outlets
    @IBOutlet weak var yearsView:UIView?
    
    
    // Instance methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        for i:Int in 1...24 {
            var lbl = self.viewWithTag(i) as UILabel
            
            if lbl.isKindOfClass(UILabel) {
                lbl.font = WLFontManager.sharedManager.bebasRegular22
            }
        }
    }
    
    func setHeight(height:CGFloat)
    {
        let ratio:CGFloat = self.frame.size.width / self.frame.size.height
        self.frame        = CGRectMake(self.frame.origin.x, self.frame.origin.y, height * ratio, height)
    
        self.yearsView!.frame = CGRectMake(0,
                                           (self.frame.size.height + 10) * 0.88,
                                           self.frame.size.width,
                                           self.yearsView!.frame.size.height);
    }

}
