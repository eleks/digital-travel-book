//
//  WLCoreTextLabelSw.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit
import CoreText

class WLCoreTextLabelSw: UILabel {

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        // Initialization code
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)
        // Initialization code
    }

    override func drawRect(rect: CGRect)
    {
        let fontName:CFStringRef    = CFStringCreateWithCString(kCFAllocatorDefault, (self.font.fontName as NSString).UTF8String, kCFStringEncodingUTF8)
        let stringRef:CFStringRef   = CFStringCreateWithCString(kCFAllocatorDefault, (self.text! as NSString).UTF8String, kCFStringEncodingUTF8)
        let attrStr:CFMutableAttributedStringRef = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0)
        
        CFAttributedStringReplaceString(attrStr, CFRangeMake(0, 0), stringRef)
        let font:CTFontRef = CTFontCreateWithName(fontName, self.font.pointSize, nil)
        
        var alignment:CTTextAlignment = CTTextAlignment.TextAlignmentLeft
        var lineBreak:CTLineBreakMode = CTLineBreakMode.ByWordWrapping
        var lineSpace:CGFloat = 0

        var setting1 = withUnsafePointer(&alignment) { (pointer: UnsafePointer<CTTextAlignment>) -> (CTParagraphStyleSetting) in
            return CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.Alignment,
                                            valueSize: UInt(sizeofValue(alignment)),
                                            value: pointer)
        }
        var setting2 = withUnsafePointer(&lineBreak) { (pointer: UnsafePointer<CTLineBreakMode>) -> (CTParagraphStyleSetting) in
            return CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.LineBreakMode,
                                            valueSize: UInt(sizeofValue(lineBreak)),
                                            value: pointer)
        }
        var setting3 = withUnsafePointer(&lineSpace) { (pointer: UnsafePointer<CGFloat>) -> (CTParagraphStyleSetting) in
            return CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.LineSpacing,
                                            valueSize: UInt(sizeofValue(lineSpace)),
                                            value: pointer)
        }
        let _settings:[CTParagraphStyleSetting] = [setting1, setting2, setting3]
        
        let paragraphStyle:CTParagraphStyleRef  = CTParagraphStyleCreate(_settings, UInt(_settings.count))

        CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle)
        CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font)
        CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTForegroundColorAttributeName, self.textColor.CGColor)
        /*
        CFRelease(paragraphStyle)
        CFRelease(font)*/
        
        let bounds:CGRect = rect
        var column:Int
        let firstColumnRect:CGRect  = CGRectMake(0, 0, bounds.size.width / 2 - 20, bounds.size.height)
        let secondColumnRect:CGRect = CGRectMake(firstColumnRect.origin.x + firstColumnRect.size.width + 40,
                                                0,
                                                bounds.size.width - (firstColumnRect.origin.x + firstColumnRect.size.width + 40),
                                                bounds.size.height)
        
        var columnRectangles:[CGRect]   = [firstColumnRect, secondColumnRect]

        
        let context:CGContextRef  = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.bounds.size.height)
        CGContextScaleCTM(context, 1, -1)
        CGContextSetCharacterSpacing(context, 30.0)

        let frameSetter:CTFramesetterRef = CTFramesetterCreateWithAttributedString(attrStr)
        let pathCount = columnRectangles.count
        var startIndex:CFIndex = 0
        
        for column in 0..<pathCount {
            var path:CGMutablePathRef = CGPathCreateMutable()
            CGPathAddRect(path, UnsafePointer.null(), columnRectangles[column])
            let frame:CTFrameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(startIndex, 0), path, nil)
            CTFrameDraw(frame, context)
            let frameRange:CFRange  = CTFrameGetVisibleStringRange(frame)
            startIndex += frameRange.length
            //CFRelease(frame)
        }
        /*
        CFRelease(array)
        CFRelease(frameSetter)
        CFRelease(attrStr)
        CFRelease(stringRef)
        CFRelease(fontName)*/
    }

}
