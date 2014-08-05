//
//  WLDetailVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

class WLDetailVCSw: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // Instance variables
    var viewControllersCache:NSCache
    var pageController:UIPageViewController? = nil
    var currentIndex:UInt = 0
    
    // Designated initializer
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        self.viewControllersCache = NSCache()
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll,
            navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal,
            options: [UIPageViewControllerOptionInterPageSpacingKey : 30])
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Convenience initializer
    convenience init(itemIndex index:UInt)
    {
        self.init(nibName: nil, bundle: nil)
        
        self.currentIndex = index
    }
    

    
    // Instance methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        self.automaticallyAdjustsScrollViewInsets = false

        self.pageController!.view.backgroundColor = RGB(48, 23, 0)
        self.pageController!.dataSource = self
        self.pageController!.delegate = self
        self.pageController!.view!.frame = self.view!.bounds
    
        var initialViewController:WLArticleVCSw = self.viewControllerAtIndex(Int(self.currentIndex))!
    
        self.pageController!.setViewControllers([initialViewController], direction:UIPageViewControllerNavigationDirection.Forward, animated:false, completion:nil)

        self.addChildViewController(self.pageController!)
        self.view.addSubview(self.pageController!.view!)
        self.pageController!.didMoveToParentViewController(self)
    
        var playerVC:WLAudioPlayerVCSw = WLAudioPlayerVCSw.playerVC
        playerVC.view!.removeFromSuperview()
        self.navigationItem.rightBarButtonItems = playerVC.toolbar!.items.reverse()
    
        let leftDrawerButton:WLMenuButton = WLMenuButton(target: self, action: Selector("btnMenuTouch:"))
        self.navigationItem!.setLeftBarButtonItem(leftDrawerButton, animated:true)
    
        self.viewControllersCache.countLimit = 3
    }
    
    func btnMenuTouch(sender:AnyObject)
    {
        self.mm_drawerController!.toggleDrawerSide(MMDrawerSide.Left, animated:true, completion:nil)
        NSNotificationCenter.defaultCenter()!.postNotificationName("Toggled drawer", object:nil)
    }
    
    func switchToViewControllerWithIndex(#index:Int, animated:Bool)
    {
        if index != Int(self.currentIndex) && index >= 0  {
            
            if index < Int(WLDataManager.sharedManager.placesList.count) {
                
                var controller:UIViewController? = self.viewControllerAtIndex(index)
                
                var direction:UIPageViewControllerNavigationDirection = (index > Int(self.currentIndex)) ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse
                var blockSafeSelf:WLDetailVCSw = self
                
                if let controller_ = controller? {
                    
                    self.pageController!.setViewControllers([controller!],
                        direction: UIPageViewControllerNavigationDirection.Forward,
                        animated:false,
                        completion:{(finished: Bool) in
                            
                            if finished {
                                dispatch_async(dispatch_get_main_queue()!, {
                                    blockSafeSelf.pageController!.setViewControllers([controller!],
                                        direction:UIPageViewControllerNavigationDirection.Forward,
                                        animated:false,
                                        completion:nil)// bug fix for uipageview controller
                                    })
                            }
                        })
                }
                
                self.currentIndex = UInt(index)
            }
        }
    }
    
    // UIPageViewControllerDataSource
    func viewControllerAtIndex(index:Int) -> WLArticleVCSw?
    {
        var detailVC:WLArticleVCSw? = self.viewControllersCache.objectForKey(index) as? WLArticleVCSw

        if index >= 0 && index < WLDataManager.sharedManager.placesList.count {
            
            var place:WLPlace = (WLDataManager.sharedManager.placesList)[Int(index)]
            detailVC = WLArticleVCSw(nibName: "WLArticleVCSw", bundle: nil)
            detailVC!.place = place
            self.viewControllersCache.setObject(detailVC!, forKey:index)
        }

        return detailVC
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController!
    {
        let index:Int = WLDataManager.sharedManager.placesList.bridgeToObjectiveC().indexOfObject((viewController as WLArticleVCSw).place!)
     
        if let vc_ = self.viewControllerAtIndex(index - 1)? {
            return vc_
        }
        else{
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController!
    {
        let index:Int = WLDataManager.sharedManager.placesList.bridgeToObjectiveC().indexOfObject((viewController as WLArticleVCSw).place!)
     
        if let vc_ = self.viewControllerAtIndex(index + 1)? {
            return vc_
        }
        else{
            return nil
        }
    }
    
    // UIPageViewControllerDelegate
    func pageViewController(pageViewController: UIPageViewController!, willTransitionToViewControllers pendingViewControllers: AnyObject[]!)
    {
        self.currentIndex = UInt(WLDataManager.sharedManager.placesList.bridgeToObjectiveC().indexOfObject(((pendingViewControllers as WLArticleVCSw[])[0] as WLArticleVCSw).place!))
        
        for article : WLArticleVCSw in pendingViewControllers as WLArticleVCSw[] {
            article.scrollToTop()
        }
    }
    
    func switchToPreviousViewControllerAnimated(animated:Bool)
    {
        self.switchToViewControllerWithIndex(index: Int(self.currentIndex) - 1, animated:animated)
    }
    
    
    func switchToNextViewControllerAnimated(animated:Bool)
    {
        self.switchToViewControllerWithIndex(index: Int(self.currentIndex) + 1, animated:animated)
    }
    
}





