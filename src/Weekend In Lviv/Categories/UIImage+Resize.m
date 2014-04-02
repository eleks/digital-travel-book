// UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"


@implementation UIImage (Resize)


// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}




// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizeImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed = NO;

    if (self.imageOrientation == UIImageOrientationLeft ||
        self.imageOrientation == UIImageOrientationLeftMirrored ||
        self.imageOrientation == UIImageOrientationRight ||
        self.imageOrientation == UIImageOrientationRightMirrored) {
        drawTransposed = YES;
    }

    return [self resizeImage:newSize transform:[self transformForOrientation:newSize] drawTransposed:drawTransposed interpolationQuality:quality];
}


// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizeImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;

    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;

        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;

        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
    }

    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);

    return [self resizeImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizeImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality {

    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;


    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = (NSUInteger) ceilf((bytesPerPixel * newRect.size.width));
    NSUInteger bitsPerComponent = 8;
    CGContextRef bitmap = CGBitmapContextCreate(NULL, (size_t) newRect.size.width, (size_t) newRect.size.height, bitsPerComponent, bytesPerRow, colorSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);

    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);

    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);

    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);

    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];

    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    CGColorSpaceRelease(colorSpace);

    return newImage;
}


// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;

    if (self.imageOrientation == UIImageOrientationDown || self.imageOrientation == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
        transform = CGAffineTransformRotate(transform, M_PI);
    }
    else if (self.imageOrientation == UIImageOrientationLeft || self.imageOrientation == UIImageOrientationLeftMirrored) {
        transform = CGAffineTransformTranslate(transform, newSize.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    }
    else if (self.imageOrientation == UIImageOrientationRight || self.imageOrientation == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, 0, newSize.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
    }

    if (self.imageOrientation == UIImageOrientationUpMirrored || self.imageOrientation == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, newSize.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }
    else if (self.imageOrientation == UIImageOrientationLeftMirrored || self.imageOrientation == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, newSize.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
    }

    return transform;
}


@end
