//
//  WLHomeItem.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLHomeItem: UIView {
    
    @IBOutlet var lblCategory : UILabel
    @IBOutlet var lblTitle : UILabel
    @IBOutlet var imgPhoto : UIImageView
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    override func awakeFromNib() {
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
