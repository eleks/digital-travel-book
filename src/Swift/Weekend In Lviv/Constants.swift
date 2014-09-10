//
//  Constants.swift
//  Weekend In Lviv
//
//  Created by Admin on 17.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//


// Global definitions
let kRotateNotification:String              = "WillRotate"
let kPushAnimationDuration:NSTimeInterval   = 0.29

func RGB(r:Float, g:Float, b:Float) -> UIColor
{
    return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(1.0))
}

// Drawing constants
let kCFStringEncodingUTF8:CFStringEncoding = 0x08000100