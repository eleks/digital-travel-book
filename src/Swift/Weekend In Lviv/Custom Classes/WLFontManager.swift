//
//  WLFontManager.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

// Singleton's shared instance of class
let _singletonFontManagerSharedInstance = WLFontManager()

class WLFontManager: NSObject{
    
    // Font constants
    let bebasRegular11      = UIFont(name: "Bebas Neue", size: 11)
    let bebasRegular12      = UIFont(name: "Bebas Neue", size: 12)
    let bebasRegular16      = UIFont(name: "Bebas Neue", size: 16)
    let bebasRegular20      = UIFont(name: "Bebas Neue", size: 20)
    let bebasRegular22      = UIFont(name: "Bebas Neue", size: 22)
    let bebasRegular32      = UIFont(name: "Bebas Neue", size: 32)
    let bebasRegular36      = UIFont(name: "Bebas Neue", size: 36)
    let bebasRegular44      = UIFont(name: "Bebas Neue", size: 44)
    let bebasRegular100     = UIFont(name: "Bebas Neue", size: 100)
    let bebasRegular120     = UIFont(name: "Bebas Neue", size: 120)
    
    let gentiumRegular12    = UIFont(name: "Gentium Book Basic", size: 12)
    let gentiumItalic15     = UIFont(name: "GentiumBookBasic-Italic", size: 15)
    let gentiumItalic20     = UIFont(name: "GentiumBookBasic-Italic", size: 20)
    let gentiumRegular16    = UIFont(name: "Gentium Book Basic", size: 16)
    
    let palatinoItalic15    = UIFont(name: "PalatinoLinotype-Italic", size: 15)
    let palatinoItalic20    = UIFont(name: "PalatinoLinotype-Italic", size: 20)
    let palatinoItalic40    = UIFont(name: "PalatinoLinotype-Italic", size: 40)
    let palatinoRegular12   = UIFont(name: "PalatinoLinotype-Roman", size: 12)
    let palatinoRegular17   = UIFont(name: "PalatinoLinotype-Roman", size: 17)
    let palatinoRegular34   = UIFont(name: "PalatinoLinotype-Roman", size: 34)
    let palatinoRegular20   = UIFont(name: "PalatinoLinotype-Roman", size: 20)
    
    // Class variable
    class var sharedManager:WLFontManager
    {
        return _singletonFontManagerSharedInstance;
    }
    
}
