//
//  WLMenuCellSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLMenuCellSw: UITableViewCell {

    // Outlets
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var imgIcon:UIImageView?
    @IBOutlet weak var imgFavoriteFlag:UIImageView?
    
    // Override methods
    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.lblTitle!.font = WLFontManager.sharedManager.palatinoItalic20
    }

}
