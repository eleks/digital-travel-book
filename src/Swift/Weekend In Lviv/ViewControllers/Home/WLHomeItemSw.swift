//
//  WLHomeItemSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLHomeItemSw: UIView {
    
    // Outlets
    @IBOutlet weak var lblCategory:UILabel?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var imgPhoto:UIImageView?
    
    // Instance methods
    override func awakeFromNib()
    {
        self.lblCategory!.font  = WLFontManager.sharedManager.palatinoRegular12
        self.lblTitle!.font     = WLFontManager.sharedManager.bebasRegular32
    }

}
