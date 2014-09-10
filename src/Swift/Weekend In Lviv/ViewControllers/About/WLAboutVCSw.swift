//
//  WLAboutVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLAboutVCSw: UIViewController, UIWebViewDelegate {

    // Outlets
    @IBOutlet weak var imgAbout:UIImageView?
    @IBOutlet weak var imgDemo:UIImageView?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var scrollView:UIScrollView?
    @IBOutlet weak var webView:UIWebView?
    
    // Static variables (from struct because swift doesn't support static var yet ! TO DO
    struct Static {
        static var padding:Int = 20
    }
    
    // Instance methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.webView!.delegate = self
        
        var playerVC = WLAudioPlayerVCSw.playerVC
        playerVC.view.removeFromSuperview()
        self.navigationItem.rightBarButtonItems = playerVC.toolbar!.items!.reverse()
        
        var leftDrawerButton = WLMenuButton(target: self, action: Selector("btnMenuTouch:"))
        self.navigationItem.setLeftBarButtonItem(leftDrawerButton, animated:true)
     
        self.lblTitle!.text = "Über ELEKS"
        self.lblTitle!.font = WLFontManager.sharedManager.bebasRegular36
        
        let aboutURL:NSURL = NSBundle.mainBundle().URLForResource("about", withExtension: "html")!
        var aboutText = String.stringWithContentsOfFile(aboutURL.path!, encoding: NSUTF8StringEncoding, error: nil)
        
        self.webView!.backgroundColor = UIColor.clearColor()
        self.webView!.opaque = false
        self.webView!.scrollView.bounces = false
        self.webView!.loadHTMLString(aboutText, baseURL: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.layoutViews()
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        self.layoutViews()
    }

    func layoutViews()
    {
        var newFrame:CGRect = self.view.frame
        
        var imgAboutFrame:CGRect = self.imgAbout!.frame
        imgAboutFrame.size.height *= newFrame.size.width / imgAboutFrame.size.width
        imgAboutFrame.size.width = newFrame.size.width
        self.imgAbout!.frame = imgAboutFrame
        
        var imgDemoFrame:CGRect = self.imgDemo!.frame
        imgDemoFrame.origin.x = newFrame.size.width - imgDemoFrame.size.width
        imgDemoFrame.origin.y = 0
        self.imgDemo!.frame = imgDemoFrame
        
        self.lblTitle!.frame = CGRectMake(CGFloat(Static.padding),
                                          CGRectGetMaxY(imgAboutFrame) + CGFloat(Static.padding),
                                          newFrame.size.width - CGFloat(Static.padding * 2),
                                          self.lblTitle!.frame.size.height);
        
        var webViewPreferredSize:CGSize = self.webView!.sizeThatFits(CGSizeZero)
        self.webView!.frame = CGRectMake(CGFloat(Static.padding),
                                         CGRectGetMaxY(self.lblTitle!.frame),
                                         newFrame.size.width - CGFloat(Static.padding * 2),
                                         max(webViewPreferredSize.height,
                                             newFrame.size.height - CGRectGetMaxY(self.lblTitle!.frame) - CGFloat(Static.padding * 2)))
        
        self.scrollView!.contentSize = CGSizeMake(newFrame.size.width, CGRectGetMaxY(self.webView!.frame))
    }
    
    func btnMenuTouch(sender:AnyObject)
    {
        self.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    func webViewDidFinishLoad(webView:UIWebView)
    {
        var webViewPreferredSize:CGSize = self.webView!.sizeThatFits(CGSizeZero)
        self.webView!.frame = CGRectMake(self.webView!.frame.origin.x,
                                         CGRectGetMaxY(self.lblTitle!.frame),
                                         self.webView!.frame.size.width,
                                         webViewPreferredSize.height)
        self.scrollView!.contentSize = CGSizeMake(self.webView!.frame.size.width, CGRectGetMaxY(self.webView!.frame))
    }

}





