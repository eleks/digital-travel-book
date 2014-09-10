//
//  UIImage+Resize.swift
//  Weekend In Lviv
//
//  Created by Admin on 18.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import Foundation

extension UIImage {
    
    // Returns a copy of this image that is cropped to the given bounds.
    // The bounds will be adjusted using CGRectIntegral.
    // This method ignores the image's imageOrientation setting.
    func croppedImage(#bounds:CGRect) -> UIImage
    {
        let imageRef:CGImageRef? = CGImageCreateWithImageInRect(self.CGImage, bounds)
        let croppedImage:UIImage? = UIImage(CGImage:imageRef!)
        //CGImageRelease(imageRef!)
        return croppedImage!
    }
    
    // Returns a rescaled copy of the image, taking into account its orientation
    // The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
    func resizeImage(#newSize:CGSize, interpolationQuality quality:CGInterpolationQuality) -> UIImage?
    {
        var drawTransposed:Bool = false
        
        if self.imageOrientation == UIImageOrientation.Left ||
           self.imageOrientation == UIImageOrientation.LeftMirrored ||
           self.imageOrientation == UIImageOrientation.Right ||
           self.imageOrientation == UIImageOrientation.RightMirrored {
                
            drawTransposed = true
        }
        return self.resizeImage(newSize:newSize,
                                transform:self.transformForOrientation(newSize:newSize),
                                drawTransposed:drawTransposed,
                                interpolationQuality:quality)
    }
    
    // Resizes the image according to the given content mode, taking into account the image's orientation
    func resizeImageWithContentMode(#contentMode:UIViewContentMode, bounds:CGSize, interpolationQuality quality:CGInterpolationQuality) -> UIImage?
    {
        let horizontalRatio:CGFloat = bounds.width / self.size.width
        let verticalRatio:CGFloat   = bounds.height / self.size.height
        var ratio:CGFloat = 1
        
        switch contentMode {
        case UIViewContentMode.ScaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
            
        case UIViewContentMode.ScaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
            
        default:
            /*NSException.raise(NSInvalidArgumentException,
                format: "Unsupported content mode: \(CLong(contentMode))",
                arguments: CVaListPointer(fromUnsafePointer: UnsafePointer()))*/
            /*NSException.raise(NSInvalidArgumentException, format: "Unsupported content mode: %@", arguments: CVaListPointer(fromUnsafePointer: UnsafePointer()))*/
            // To DO !!! PROBLEM WITH CVaListPointer !!!
            self.foo()
        }
        let newSize:CGSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio)
        
        return self.resizeImage(newSize:newSize, interpolationQuality:quality)
    }
    
    func foo()
    {
        
    }

    // Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
    // The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
    // If the new size is not integral, it will be rounded up
    func resizeImage(#newSize:CGSize, transform:CGAffineTransform, drawTransposed transpose:Bool, interpolationQuality quality:CGInterpolationQuality) -> UIImage?
    {
        var newRect:CGRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height))
        var transposedRect:CGRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width)
        var imageRef:CGImageRef = self.CGImage!
        
        var colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel:CGFloat = 4
        let bytesPerRow:Int = Int(ceilf(CFloat(bytesPerPixel * newRect.size.width)))
        let bitsPerComponent:Int = 8
        
        var bitmap:CGContextRef? = CGBitmapContextCreate(nil,
                                                        UInt(newRect.size.width),
                                                        UInt(newRect.size.height),
                                                        UInt(bitsPerComponent),
                                                        UInt(bytesPerRow),
                                                        colorSpace,
                                                        CGBitmapInfo(CGBitmapInfo.ByteOrder32Big.toRaw() | CGImageAlphaInfo.PremultipliedLast.toRaw()))
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(bitmap!, transform)
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap!, quality)
        
        // Draw into the context; this scales the image
        CGContextDrawImage(bitmap!, transpose ? transposedRect : newRect, imageRef)
        
        // Get the resized image from the context and a UIImage
        var newImageRef:CGImageRef? = CGBitmapContextCreateImage(bitmap!)
        var newImage:UIImage? = UIImage(CGImage:newImageRef!)
        
        // Clean up
        //CGContextRelease(bitmap!)
        //CGImageRelease(newImageRef!)
        //CGColorSpaceRelease(colorSpace)
        
        return newImage
    }
    
    // Returns an affine transform that takes into account the image orientation when drawing a scaled image
    func transformForOrientation(#newSize:CGSize) -> CGAffineTransform
    {
        var transform:CGAffineTransform = CGAffineTransformIdentity
        
        if self.imageOrientation == UIImageOrientation.Down ||
           self.imageOrientation == UIImageOrientation.DownMirrored {
            
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        else if self.imageOrientation == UIImageOrientation.Left ||
                self.imageOrientation == UIImageOrientation.LeftMirrored {
                
            transform = CGAffineTransformTranslate(transform, newSize.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        else if self.imageOrientation == UIImageOrientation.Right ||
                self.imageOrientation == UIImageOrientation.RightMirrored {
                    
            transform = CGAffineTransformTranslate(transform, 0, newSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        }
        
        if self.imageOrientation == UIImageOrientation.UpMirrored ||
           self.imageOrientation == UIImageOrientation.DownMirrored {
            
            transform = CGAffineTransformTranslate(transform, newSize.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        }
        else if self.imageOrientation == UIImageOrientation.LeftMirrored ||
               self.imageOrientation == UIImageOrientation.RightMirrored {
                
            transform = CGAffineTransformTranslate(transform, newSize.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        return transform
    }
    
}

