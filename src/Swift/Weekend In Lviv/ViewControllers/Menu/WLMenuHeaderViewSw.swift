//
//  WLMenuHeaderViewSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLMenuHeaderViewSw: UIView {

    // Outlets
    @IBOutlet weak var lblTitle:UILabel
    @IBOutlet weak var lineLeft:UIView
    @IBOutlet weak var lineRight:UIView
    
    
    // Instance methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.lblTitle.font = WLFontManager.sharedManager.bebasRegular16
    }
    
    
    func setTitle(titleText:String)
    {
        self.lblTitle.text = titleText
        self.lblTitle.sizeToFit()
        
        self.lblTitle.frame = CGRectMake((self.frame.size.width - self.lblTitle.frame.size.width) / 2,
                                            (self.frame.size.height - self.lblTitle.frame.size.height) / 2,
                                            self.lblTitle.frame.size.width,
                                            self.lblTitle.frame.size.height)
        self.lineLeft.frame = CGRectMake(10,
                                            (self.frame.size.height - self.lineLeft.frame.size.height) / 2,
                                            self.lblTitle.frame.origin.x - 30,
                                            self.lineLeft.frame.size.height)
        self.lineRight.frame = CGRectMake(self.lblTitle.frame.origin.x + self.lblTitle.frame.size.width + 10,
                                            (self.frame.size.height - self.lineRight.frame.size.height) / 2,
                                            self.frame.size.width - (self.lblTitle.frame.origin.x + self.lblTitle.frame.size.width + 30),
                                            self.lineRight.frame.size.height)
    }

}
