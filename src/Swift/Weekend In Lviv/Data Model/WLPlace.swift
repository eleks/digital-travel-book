//
//  WLPlace.swift
//  Weekend In Lviv
//
//  Created by Admin on 19.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import Foundation

class WLPlace : NSObject {
    
    var title:String                        = ""
    var placeText:String                    = ""
    var placeTopImagePath:String            = ""
    var placeMenuImagePath:String           = ""
    var listImagePath:String                = ""
    var placesTextBlocks:WLTextBlock[]      = []
    var placesPointBlocks:WLPointBlock[]    = []
    var placeAudioPath:String               = ""
    var placeFavourite:Bool                 = false
    var moIdentificator:NSNumber            = 0
    
}