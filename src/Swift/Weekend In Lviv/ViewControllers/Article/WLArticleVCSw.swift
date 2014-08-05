//
//  WLArticleVCSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit
import QuartzCore

class WLArticleVCSw: UIViewController, UIPopoverControllerDelegate, WLDetailBlockDelegate {

    // Outlets
    @IBOutlet weak var btnAddToFavourites:UIButton
    @IBOutlet weak var scrollDetail:UIScrollView
    @IBOutlet weak var lblFirst:WLCoreTextLabelSw
    @IBOutlet weak var swipeLayer:UIView
    @IBOutlet weak var lblSwipe:UILabel
    @IBOutlet weak var imgTop:UIImageView
    @IBOutlet weak var lblPlaceTitle:UILabel
    @IBOutlet weak var btnPlayAudio:UIButton

    var textBlocks = Dictionary<Int, WLArticleBlockSw>()
    var pointBlocks = Dictionary<Int, WLPointBlockViewSw>()
    var galleryPresented:Bool = false

    weak var _place:WLPlace? = nil
    weak var place:WLPlace? {
        get {
            return _place
        }
        set (place) {
            _place = place
            self.setupSwipeTip()
        }
    }

    
    // Instance methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.scrollDetail.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        self.galleryPresented = false
        
        self.lblSwipe.font = WLFontManager.sharedManager.gentiumItalic15
        self.lblFirst.font = WLFontManager.sharedManager.palatinoRegular20
        self.lblPlaceTitle.font = WLFontManager.sharedManager.bebasRegular100
        self.btnPlayAudio.titleLabel.font = WLFontManager.sharedManager.bebasRegular16
        
        self.lblPlaceTitle.text = self.place!.title
        
        var moPlace:Place = WLDataManager.sharedManager.placeWithIdentifier(self.place!.moIdentificator)
        if moPlace.favourite.boolValue {
            self.btnAddToFavourites.setImage(UIImage(named:"BtnFavoriteBkg"), forState: UIControlState.Normal)
        }
        else {
            self.btnAddToFavourites.setImage(UIImage(named:"BtnFavoriteBkg_inactive"), forState:UIControlState.Normal)
        }
        
        self.setupSwipeTip()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.setScrollLayoutForOrientation(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    
    override func viewWillLayoutSubviews()
    {
        self.setScrollLayoutForOrientation(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool
    {
        return true
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        NSNotificationCenter.defaultCenter()!.postNotificationName(kRotateNotification, object: nil)
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval)
    {
        self.setScrollLayoutForOrientation(toInterfaceOrientation)
    }
    
    func setScrollLayoutForOrientation(orientation:UIInterfaceOrientation)
    {
        var topImage:UIImage? = WLDataManager.sharedManager.imageWithPath(self.place!.placeTopImagePath)
        if let topImage_ = topImage? {
            self.imgTop.image = topImage_
        }
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            self.view.frame = CGRectMake(0, 0, 1024, 768)
            self.imgTop.frame = CGRectMake(0, 0, 1024, 452)
            self.lblPlaceTitle!.frame = CGRectMake(self.lblPlaceTitle.frame.origin.x, 40, self.lblPlaceTitle.frame.size.width, self.lblPlaceTitle.frame.size.height)
            self.btnPlayAudio.frame = CGRectMake(self.btnPlayAudio.frame.origin.x, 340, self.btnPlayAudio.frame.size.width, self.btnPlayAudio.frame.size.height)
        }
        else {
            self.view.frame = CGRectMake(0, 0, 768, 1024);
            self.imgTop.frame = CGRectMake(0, 0, 768, 452 * 0.75)
            self.lblPlaceTitle.frame = CGRectMake(self.lblPlaceTitle.frame.origin.x, 20, self.lblPlaceTitle.frame.size.width, self.lblPlaceTitle.frame.size.height)
            self.btnPlayAudio.frame = CGRectMake(self.btnPlayAudio.frame.origin.x, 270, self.btnPlayAudio.frame.size.width, self.btnPlayAudio.frame.size.height)
        }
        self.lblFirst.frame = CGRectMake(self.lblFirst.frame.origin.x, self.imgTop.frame.size.height + 40, self.lblFirst.frame.size.width, self.lblFirst.frame.size.height);
    
        let textBoundingRec:CGRect = self.lblPlaceTitle.text.bridgeToObjectiveC().boundingRectWithSize(self.lblPlaceTitle.frame.size,
                                                                                                        options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                                                                        attributes: [NSFontAttributeName : self.lblPlaceTitle.font],
                                                                                                        context: nil)
        let textSize:CGSize = !CGRectIsNull(textBoundingRec) ? textBoundingRec.size : CGSizeZero
    
        let textRect:CGRect = CGRectMake(self.lblPlaceTitle.frame.origin.x, self.lblPlaceTitle.frame.origin.y, self.lblPlaceTitle.frame.size.width, textSize.height)
        self.lblPlaceTitle.frame = textRect
        self.lblPlaceTitle.setNeedsDisplay()
    
        self.setDescriptionText(self.place!.placeText)
    
        let rowsCount:Int = self.place!.placesTextBlocks.count
        let thumbWidth:CGFloat = self.scrollDetail!.frame.size.width
        let x = CGFloat(0)
        var y = CGFloat(self.lblFirst!.frame.origin.y + self.lblFirst!.frame.size.height + 40)
 
        for i:Int in 1...rowsCount {
  
            var itemView:WLArticleBlockSw? = self.textBlocks[i]
            
            if let itemView_ = itemView? {
                itemView_.layout()
            }
            else {
                var textBlock:WLTextBlock? = (self.place!.placesTextBlocks)[i - 1]
                itemView = NSBundle.mainBundle()!.loadNibNamed("WLArticleBlockSw", owner: nil, options: nil)[0] as? WLArticleBlockSw
                itemView!.setLayoutWithTextBlock(textBlock!)
                itemView!.delegate = self
            
                self.textBlocks[i] = itemView!
            }
    
            itemView!.frame = CGRectMake(x, y, thumbWidth, itemView!.frame.size.height)
            self.scrollDetail!.addSubview(itemView)
            y += itemView!.frame.size.height
        }
    
        let pointBlockCount:Int = self.place!.placesPointBlocks.count
        
        for i:Int in 1...pointBlockCount {
            
            var itemView:WLPointBlockViewSw? = self.pointBlocks[i]
            
            if let itemView_ = itemView? {
                
                itemView_.layout()
            }
            else {
                var pointBlock:WLPointBlock = (self.place!.placesPointBlocks)[i - 1]
                itemView = NSBundle.mainBundle()!.loadNibNamed("WLPointBlockViewSw", owner: nil, options: nil)[0] as? WLPointBlockViewSw
                
                itemView!.setLayoutWithPointBlock(pointBlock)
                
                self.pointBlocks[i] = itemView!
            }
    
            itemView!.frame = CGRectMake(x, y, thumbWidth, itemView!.frame.size.height)
            self.scrollDetail.addSubview(itemView)
            y += itemView!.frame.size.height
        }
    
        self.swipeLayer.frame = CGRectMake(0, y, self.swipeLayer.frame.size.width, self.swipeLayer.frame.size.height)
        y += self.swipeLayer.frame.size.height;
    
        let contentWidth:CGFloat = self.scrollDetail!.frame.size.width
        let contentHeight:CGFloat  = y
        self.scrollDetail.contentSize = CGSizeMake(contentWidth, contentHeight)
    }
    
    func setDescriptionText(text:String)
    {
        if text.bridgeToObjectiveC().length > 0 {
            var lblWidth:CGFloat
            if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication()!.statusBarOrientation)) {
                lblWidth = CGFloat(944)
            }
            else{
                lblWidth = CGFloat(688)
            }
            
            let firstSize:CGSize = text.bridgeToObjectiveC().boundingRectWithSize(CGSizeMake(lblWidth / 2 - 40, CGFloat(MAXFLOAT)),
                options:NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes:[NSFontAttributeName : self.lblFirst.font],
                context:nil).size
            self.lblFirst.text = text
            self.lblFirst.frame = CGRectMake(self.lblFirst.frame.origin.x, self.lblFirst.frame.origin.y, lblWidth, firstSize.height / 2 + 40)
        }
        else {
            self.lblFirst.text = ""
        }
    }
    
    func pushControllerWithAnimation(controller:UIViewController, view:UIView)
    {
        weak var weakSelf = self
        
        var  transitionView:UIImageView = UIImageView(frame:view.frame)
        transitionView.image = (view as UIImageView).image
        view.superview.addSubview(transitionView)
        view.hidden = true
        UIView.animateWithDuration(kPushAnimationDuration,
            animations: {
            
                let moveY:CATransform3D = CATransform3DMakeTranslation (0, 0, transitionView.frame.size.height)
                let rotateView:CATransform3D = CATransform3DMakeRotation(CGFloat(Float(0.0174532925) * -90), 1, 0, 0)
                let finishedTransform:CATransform3D = CATransform3DConcat(rotateView, moveY)
                transitionView.layer.transform = finishedTransform
            },
            completion: {(value: Bool) in
        
                let strongSelf = weakSelf
                let viewTransform:CATransform3D = transitionView.layer.transform
                let controllerScale:CATransform3D = CATransform3DMakeScale(transitionView.frame.size.width / controller.view.frame.size.width,
                                                                           transitionView.frame.size.height / controller.view.frame.size.height,
                                                                           0)
                
                let controllerFinishedTransform:CATransform3D = CATransform3DConcat(viewTransform, controllerScale)
                controller.view.layer.transform = controllerFinishedTransform
                
                let viewRect:CGRect = transitionView.convertRect(transitionView.bounds, toView:strongSelf!.view)
                let controllerRect:CGRect = controller.view.frame
                
                let controllerTransY:CGFloat = viewRect.origin.y - controllerRect.origin.y
                let controllerTransX:CGFloat = viewRect.origin.x - controllerRect.origin.x
                let controllerTranslate:CATransform3D = CATransform3DMakeTranslation(controllerTransX, controllerTransY, 0)
                let controllerTransform:CATransform3D = CATransform3DConcat(controller.view.layer.transform, controllerTranslate)
                
                controller.view.layer.transform = controllerTransform
                strongSelf!.view.addSubview(controller.view)

                UIView.animateWithDuration(kPushAnimationDuration,
                    animations:{
                        controller.view.layer.transform = CATransform3DIdentity
                    },
                    completion:{(value: Bool) in
                        
                        strongSelf!.navigationController!.pushViewController(controller, animated:false)
                        strongSelf!.view.userInteractionEnabled = true
                        strongSelf!.galleryPresented = false
                        view.hidden = false
                        
                })
            })
    }
    
    func tapOnImageWithPath(imagePath:String, imageContainer imageView:UIImageView)
    {
        if (!self.galleryPresented) {
            self.view.userInteractionEnabled = false
            self.galleryPresented = true
    
            var photoVC:WLPhotoGalleryVCSw? = WLPhotoGalleryVCSw(nibName: "WLPhotoGalleryVCSw", bundle: nil)
            
            photoVC!.imagePathList = WLDataManager.sharedManager.imageListWithPlace(self.place!)
            let index:Int? = photoVC!.imagePathList.bridgeToObjectiveC().indexOfObject(imagePath)
            
            if let index_ = index? {
                photoVC!.selectedImageIndex = UInt(index_)
            }
            photoVC!.view!.frame = self.view!.frame
    
            NSNotificationCenter.defaultCenter()!.postNotificationName("HidePlayer", object:nil)
            self.pushControllerWithAnimation(photoVC!, view:imageView)
        }
    }
    
    func setupSwipeTip()
    {
        let index:Int = WLDataManager.sharedManager.placesList.bridgeToObjectiveC().indexOfObject(self.place!)

        if let swipeLabel = self.lblSwipe? {
            
            if index == 0 {
                swipeLabel.text = "swipe right"
            }
            else if (index == WLDataManager.sharedManager.placesList.count - 1) {
                swipeLabel.text = "swipe left"
            }
        }
    }
    
    func scrollToTop()
    {
        self.scrollDetail!.contentOffset = CGPointMake(0, -64)
    }
    
    // Actions
    @IBAction func btnPlayAudioTouch(sender:UIButton)
    {
        NSNotificationCenter.defaultCenter()!.postNotificationName("playAudioFile", object: self, userInfo: ["file": self.place!.placeAudioPath])
    }
    
    @IBAction func btnBackwardTouch(sender:AnyObject)
    {
        var detailController:WLDetailVCSw? = self.parentViewController.parentViewController as? WLDetailVCSw

        if let detailController_ = detailController? {
            detailController_.switchToPreviousViewControllerAnimated(true)
        }
    }
    
    @IBAction func btnForwardTouch(sender:AnyObject)
    {
        var detailController:WLDetailVCSw? = self.parentViewController.parentViewController as? WLDetailVCSw
 
        if let detailController_ = detailController? {
            detailController_.switchToNextViewControllerAnimated(true)
        }
    }
    
    @IBAction func btnAddToFavouriteTouch(sender:AnyObject)
    {
        var moPlace:Place? = WLDataManager.sharedManager.placeWithIdentifier(self.place!.moIdentificator)
        if let moPlace_ = moPlace? {
            if moPlace_.favourite.boolValue {
                moPlace_.favourite = NSNumber(bool: false)
                self.place!.placeFavourite = false
                self.btnAddToFavourites.setImage(UIImage(named:"BtnFavoriteBkg_inactive"), forState:UIControlState.Normal)
            }
            else {
                moPlace_.favourite = NSNumber(bool: true)
                self.place!.placeFavourite = true
                self.btnAddToFavourites.setImage(UIImage(named:"BtnFavoriteBkg"), forState:UIControlState.Normal)
            }
            WLDataManager.sharedManager.saveContext()
            NSNotificationCenter.defaultCenter()!.postNotificationName("ArticleStatusChanged", object:nil)
        }
    }
 
}
