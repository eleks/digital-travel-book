//
//  WLPhotoGalleryVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class ImageViewController:UIViewController {
    
    // Instance variables
    var index:UInt = 0
    var imageView:UIImageView? = nil
    
    var _imagePath:String = ""
    var imagePath:String {
        get {
            return _imagePath
        }
        set (imagePath) {
            _imagePath = imagePath
            
            if let imageView_ = imageView? {
                imageView_.removeFromSuperview()
            }
            self.imageView              = UIImageView(image: UIImage(contentsOfFile: self.imagePath))
            self.imageView!.frame       = self.view.bounds
            self.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
            self.view = self.imageView!
        }
    }
}


class WLPhotoGalleryVCSw: UIViewController, UIScrollViewDelegate, UIPageViewControllerDataSource {

    // Outlets
    @IBOutlet weak var scrollImages:UIScrollView?
    @IBOutlet weak var lblSwipe:UILabel?
    @IBOutlet weak var btnClose:UIButton?
    
    
    // Instance variables
    var imagePathList: [String] = []
    var selectedImageIndex:UInt = 0
    var pageController:UIPageViewController? = nil
    
    
    // Instance methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblSwipe!.font = WLFontManager.sharedManager.gentiumItalic15
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll,
                                                  navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal,
                                                  options:nil)
        let initialViewController:UIViewController? = self.viewControllerAtIndex(Int(self.selectedImageIndex))
        
        if let initVC_ = initialViewController? {
            self.pageController!.setViewControllers([initVC_],
                                                    direction:UIPageViewControllerNavigationDirection.Forward,
                                                    animated:false,
                                                    completion:nil)
        }
        self.addChildViewController(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        self.pageController!.didMoveToParentViewController(self)
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    
        self.pageController!.dataSource = self
        self.pageController!.view.frame = self.view.bounds
        self.pageController!.view.frame = self.scrollImages!.frame
        self.view.addSubview(self.pageController!.view)
    
        self.view.bringSubviewToFront(self.btnClose!)
        self.btnClose!.enabled = true
        self.view.bringSubviewToFront(self.lblSwipe!)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIView())
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().postNotificationName("ShowPlayer", object:nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    /* Unavailable in Swift
    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation:UIInterfaceOrientation) -> Bool
    {
        return true
    }*/
    
    func btnMenuTouch(sender:AnyObject)
    {
        self.mm_drawerController!.toggleDrawerSide(MMDrawerSide.Left, animated:true, completion:nil)
    }
    
    
    
    
    //#pragma mark - Page view controller delegate
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let imageController = viewController as ImageViewController
        return self.viewControllerAtIndex(Int(imageController.index) - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let imageController = viewController as ImageViewController
        return self.viewControllerAtIndex(Int(imageController.index) + 1)
    }
    
    func viewControllerAtIndex(index:Int) -> ImageViewController?
    {
        var photoVC:ImageViewController? = nil
    
        if index >= 0 && index < self.imagePathList.count {
            photoVC = ImageViewController()
            photoVC!.imagePath = self.imagePathList[Int(index)]
            photoVC!.index = UInt(index)
        }
        return photoVC
    }
    
    //#pragma mark - Page view controller data source
    
    

    // Actions
    @IBAction func btnCloseTouch(sender:AnyObject)
    {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
}
