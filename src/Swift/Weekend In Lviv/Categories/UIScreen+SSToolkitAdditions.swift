//
//  UIScreen+SSToolkitAdditions.swift
//  Weekend In Lviv
//
//  Created by Admin on 18.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import Foundation


// Extension for class (category)
extension UIScreen {
    
    func currentBounds() -> CGRect
    {
        return self.boundsForOrientation(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    func boundsForOrientation(orientation:UIInterfaceOrientation) -> CGRect
    {
        
        var bounds:CGRect = self.bounds
        if orientation.isLandscape {
            
            let buffer:CGFloat  = bounds.size.width;
            bounds.size.width   = bounds.size.height;
            bounds.size.height  = buffer;
        }
        return bounds
    }
    
    func isRetinaDisplay() -> Bool
    {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var isRetinaDisplayOnCurrentDevice:Bool = false
        }
        dispatch_once(&Static.onceToken) {
            Static.isRetinaDisplayOnCurrentDevice = (self.respondsToSelector(Selector("scale")) && self.scale == 2)
        }
        return Static.isRetinaDisplayOnCurrentDevice
    }
    
}