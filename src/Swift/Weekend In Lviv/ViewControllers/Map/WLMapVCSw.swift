//
//  WLMapVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLMapVCSw: UIViewController {

    // Override methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }

    // Actions
    @IBAction func btnBackTouch(sender:AnyObject)
    {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
}

