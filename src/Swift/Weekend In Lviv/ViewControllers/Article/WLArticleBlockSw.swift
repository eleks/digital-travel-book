//
//  WLArticleBlockSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit


protocol WLDetailBlockDelegate:NSObjectProtocol {

    func tapOnImageWithPath(imagePath:String, imageContainer imageView:UIImageView)
}



class WLArticleBlockSw: UIView {

    // Outlets
    @IBOutlet weak var lblSubtitle:UILabel?
    @IBOutlet weak var lblTitle:UILabel?
    @IBOutlet weak var lblFirstColumn:WLCoreTextLabelSw?
    @IBOutlet weak var scrollImages:UIScrollView?
    @IBOutlet weak var textLayer:UIView?
 
    // Variables
    weak var delegate:WLArticleVCSw? = nil
    var loadedImages:[UIImage]   = []
    var imageViews:[UIImageView] = []
    
    // Designated initializers
    override  init(frame: CGRect)
    {
        super.init(frame: frame)
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        // Initialization code
    }

    
    // Override methods
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.lblFirstColumn!.font    = WLFontManager.sharedManager.palatinoRegular20
        self.lblTitle!.font          = WLFontManager.sharedManager.bebasRegular36
        self.lblSubtitle!.font       = WLFontManager.sharedManager.palatinoRegular17
        self.scrollImages!.pagingEnabled = true
    }
    
    
    
    
    // Instance methods
    func setDescriptionText(text:String)
    {
        if text.utf16Count > 0 {
            var lblWidth:CGFloat
            
            if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().delegate!.window!!.rootViewController!.interfaceOrientation)) {
                lblWidth = 944
            }
            else {
                lblWidth = 688
            }
    
            let firstSize:CGSize  = (text as NSString).boundingRectWithSize(CGSizeMake(lblWidth / 2 - 40, CGFloat(MAXFLOAT)),
                                                                            options:NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                                            attributes:[NSFontAttributeName : self.lblFirstColumn!.font],
                                                                            context:nil).size
            self.lblFirstColumn!.text = text
            self.lblFirstColumn!.frame = CGRectMake(self.lblFirstColumn!.frame.origin.x,
                                                    self.lblFirstColumn!.frame.origin.y,
                                                    self.lblFirstColumn!.frame.size.width,
                                                    firstSize.height / 2)
            self.textLayer!.frame = CGRectMake(0,
                                               self.scrollImages!.frame.size.height,
                                               self.frame.size.width,
                                               self.lblFirstColumn!.frame.origin.y + firstSize.height / 2 + 40)
            self.frame = CGRectMake(self.frame.origin.x,
                                    self.frame.origin.y,
                                    self.frame.size.width,
                                    self.textLayer!.frame.origin.y + self.textLayer!.frame.size.height)
        }
        else {
            self.lblFirstColumn!.text = ""
        }
    }
    
    func setImages(imageList:[String])
    {
        self.textLayer!.frame = CGRectMake(0,
                                           self.scrollImages!.frame.size.height,
                                           self.textLayer!.frame.size.width,
                                           self.textLayer!.frame.size.height)
        for imagePath in imageList {
            
            let image:UIImage = WLDataManager.sharedManager.imageWithPath(imagePath as String)
            self.loadedImages.append(image)
    
            var imageView:WLImageView = WLImageView()
            imageView.image = image
            var tap = UITapGestureRecognizer(target: self, action: Selector("tapOnImage:"))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            imageView.userInteractionEnabled = true
            imageView.imagePath = imagePath
    
            self.imageViews.append(imageView)
            self.scrollImages!.addSubview(imageView)
        }
        self.layout()
    }
    
    func setLayoutWithTextBlock(textBlock:WLTextBlock)
    {
        self.setImages(textBlock.blockImagesPath)
        self.setDescriptionText(textBlock.blockText)
        self.lblTitle!.text = textBlock.blockTitle
        self.lblSubtitle!.text = textBlock.blockSubtitle
    }
    
    func tapOnImage(sender:UITapGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Ended {
            if self.delegate != nil && self.delegate!.respondsToSelector(Selector("tapOnImageWithPath:imageContainer:")) {
                var imageView:WLImageView = sender.view as WLImageView
                self.delegate!.tapOnImageWithPath(imageView.imagePath!, imageContainer:imageView)
            }
        }
    }
    
    func layout()
    {
        let screenScale:CGFloat = UIScreen.mainScreen().isRetinaDisplay() ? CGFloat(2.0) : CGFloat(1.0)
    
        self.textLayer!.frame = CGRectMake(0,
                                           self.scrollImages!.frame.size.height,
                                           self.textLayer!.frame.size.width,
                                           self.textLayer!.frame.size.height);
        var x = CGFloat(0)
        var y = CGFloat(0)
        for i:Int in 0..<self.loadedImages.count {
            
            var image:UIImage = self.loadedImages[i]
            var imageView:UIImageView = self.imageViews[i]
    
            //println("layout \(image) \(NSStringFromCGSize(image.size))")
            y = image.size.height / screenScale
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            
            if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().delegate!.window!!.rootViewController!.interfaceOrientation) {
                imageView.frame = CGRectMake(x, 0, image.size.width / screenScale, image.size.height / screenScale)
            }
            else {
                imageView.frame = CGRectMake(x, 0, image.size.width * 0.75 / screenScale, image.size.height * 0.75 / screenScale)
            }
            x += imageView.frame.size.width
        }
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().delegate!.window!!.rootViewController!.interfaceOrientation) {
            self.scrollImages!.frame = CGRectMake(0, 0, self.scrollImages!.frame.size.width, y)
        }
        else {
            self.scrollImages!.frame = CGRectMake(0, 0, self.scrollImages!.frame.size.width, y * 0.75)
        }
        self.scrollImages!.contentSize = CGSizeMake(x, self.scrollImages!.frame.size.height)
    
        if self.lblFirstColumn!.text!.utf16Count > 0 {
            var lblWidth:CGFloat
            if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().delegate!.window!!.rootViewController!.interfaceOrientation) {
                lblWidth = 944
            }
            else {
                lblWidth = 688
            }
    
            let firstSize:CGSize = (self.lblFirstColumn!.text! as NSString).boundingRectWithSize(CGSizeMake(lblWidth / 2 - 40, CGFloat(MAXFLOAT)),
                                                                                                 options:NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                                                                 attributes:[NSFontAttributeName : self.lblFirstColumn!.font],
                                                                                                 context:nil).size
            self.lblFirstColumn!.frame = CGRectMake(self.lblFirstColumn!.frame.origin.x,
                                                    self.lblFirstColumn!.frame.origin.y,
                                                    self.lblFirstColumn!.frame.size.width,
                                                    firstSize.height / 2)
            self.textLayer!.frame = CGRectMake(0,
                                               self.scrollImages!.frame.size.height,
                                               self.frame.size.width,
                                               self.lblFirstColumn!.frame.origin.y + firstSize.height / 2 + 40)
            self.frame = CGRectMake(self.frame.origin.x,
                                    self.frame.origin.y,
                                    self.frame.size.width,
                                    self.textLayer!.frame.origin.y + self.textLayer!.frame.size.height)
        }
    }

}





