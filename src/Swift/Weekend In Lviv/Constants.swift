//
//  Constants.swift
//  Weekend In Lviv
//
//  Created by Admin on 17.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

// TO DO !!!!
// Imports
/*import Availability
import UIKit/UIKit
import Foundation/Foundation
import CoreData/CoreData
import CoreData/CoreText
import MediaPlayer/MediaPlayer
import QuartzCore/QuartzCore
*/

// Global definitions
let kRotateNotification:String              = "WillRotate"
let kPushAnimationDuration:NSTimeInterval   = 0.29

func RGB(r:Float, g:Float, b:Float) -> UIColor
{
    
    return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
}

// Drawing constants
let kCFStringEncodingUTF8:CFStringEncoding = 0x08000100