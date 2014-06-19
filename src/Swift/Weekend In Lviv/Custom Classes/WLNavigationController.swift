//
//  WLNavigationController.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLNavigationController: UINavigationController, UINavigationControllerDelegate{

    // Instance variables
    var completionBlock:dispatch_block_t? = nil
    var pushedVC:UIViewController? = nil
    
    
    // Instance methods
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.delegate = self
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }

    func navigationController(navigationController: UINavigationController!,
        didShowViewController viewController: UIViewController!,
        animated: Bool)
    {
        if self.completionBlock && self.pushedVC {
            
            self.completionBlock!()
            self.completionBlock = nil
            self.pushedVC = nil
        }
        else if self.completionBlock && viewController == self.viewControllers[0] as UIViewController {
            
            self.completionBlock!()
            self.completionBlock = nil
        }
    }
    
    func navigationController(navigationController: UINavigationController!,
                                willShowViewController viewController: UIViewController!,
                                animated: Bool)
    {
        if self.pushedVC != viewController && viewController != self.viewControllers[0] as UIViewController {
            
            self.pushedVC = nil
            self.completionBlock = nil
        }
    }
    
    func pushViewController(#viewController:UINavigationController,
                            animated:Bool,
                            completion:dispatch_block_t)
    {
        
        self.pushedVC = viewController
        self.completionBlock = completion
        self.pushViewController(viewController, animated: animated)
    }

}
