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
    var currentIndex:UInt
    
    
    
    // Designated initializers
    init(itemIndex index:UInt)
    {
        self.viewControllersCache = NSCache()
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll,
                                                    navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal,
                                                    options: [UIPageViewControllerOptionInterPageSpacingKey : 30])
        self.currentIndex = index
        
        super.init(nibName: nil, bundle: nil)
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
    
        var initialViewController:WLArticleVCSw = self.viewControllerAtIndex(self.currentIndex)
    
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
    
    func switchToViewControllerWithIndex(#index:UInt, animated:Bool)
    {
        if (self.currentIndex == index) {
            return;
        }
        if index < UInt(WLDataManager.sharedManager.placesList.count) {
            
            var controller:UIViewController = self.viewControllerAtIndex(index)
            
            var direction:UIPageViewControllerNavigationDirection = (index > self.currentIndex) ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse
            var blockSafeSelf:WLDetailVCSw = self
            
            self.pageController!.setViewControllers([controller],
                                                    direction: UIPageViewControllerNavigationDirection.Forward,
                                                    animated:false,
                completion:{(finished: Bool) in
                    
                    if finished {
                        dispatch_async(dispatch_get_main_queue()!, {
                            blockSafeSelf.pageController!.setViewControllers([controller],
                                                                            direction:UIPageViewControllerNavigationDirection.Forward,
                                                                            animated:false,
                                                                            completion:nil)// bug fix for uipageview controller
                            })
                    }
                })
            self.currentIndex = index
        }
    }
    
    // UIPageViewControllerDataSource
    func viewControllerAtIndex(index:UInt) -> WLArticleVCSw
    {/*
        var detailVC:WLArticleVCSw = self.viewControllersCache.objectForKey(index) as WLArticleVCSw
        
        if index < UInt(WLDataManager.sharedManager.placesList.count) {
            
            var place:WLPlace = (WLDataManager.sharedManager.placesList)[Int(index)]
            detailVC = WLArticleVCSw(nibName: "WLArticleVC", bundle: nil)
            detailVC.place = place;
            self.viewControllersCache.setObject(detailVC, forKey:index)
        }
        return detailVC*/
        return WLArticleVCSw()
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController!
    {
        let index:Int = WLDataManager.sharedManager.placesList.bridgeToObjectiveC().indexOfObject((viewController as WLArticleVCSw).place!)
        return self.viewControllerAtIndex(UInt(index - 1))
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController!
    {
        let index:Int = WLDataManager.sharedManager.placesList.bridgeToObjectiveC().indexOfObject((viewController as WLArticleVCSw).place!)
        return self.viewControllerAtIndex(UInt(index + 1))
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
        self.switchToViewControllerWithIndex(index: self.currentIndex - 1, animated:animated)
    }
    
    
    func switchToNextViewControllerAnimated(animated:Bool)
    {
        self.switchToViewControllerWithIndex(index: self.currentIndex + 1, animated:animated)
    }
    
}





