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

    init(frame: CGRect)
    {
        super.init(frame: frame)
        // Initialization code
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
        // Initialization code
    }
/*
    override func drawRect(rect: CGRect)
    {
        let fontName:CFStringRef = CFStringCreateWithCString(kCFAllocatorDefault, self.font.fontName.bridgeToObjectiveC().UTF8String, kCFStringEncodingUTF8)
        
        let stringRef:CFStringRef = CFStringCreateWithCString(kCFAllocatorDefault, self.text.bridgeToObjectiveC().UTF8String, kCFStringEncodingUTF8)
        let attrStr:CFMutableAttributedStringRef = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0)
        CFAttributedStringReplaceString(attrStr, CFRangeMake(0, 0), stringRef)
        let font:CTFontRef = CTFontCreateWithName(fontName, self.font.pointSize, nil)
        
        var alignment:CTTextAlignment = CTTextAlignment.TextAlignmentLeft
        var lineBreak:CTLineBreakMode = CTLineBreakMode.ByWordWrapping
        var lineSpace:CGFloat = 0

        withUnsafePointer(&alignment) { (pointer1: UnsafePointer<CTTextAlignment>) -> (CTTextAlignment) in
            
            
        }
        var lineBreakPointer = withUnsafePointer(&lineBreak) { (pointer2: UnsafePointer<CTLineBreakMode>) -> (CTLineBreakMode) in
            return lineBreak
        }
        var lineSpacePointer = withUnsafePointer(&lineSpace) { (pointer3: UnsafePointer<CGFloat>) -> (CGFloat) in
            return lineSpace
        }
        
        let _settings:CTParagraphStyleSetting[] = [CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.Alignment,
                                                                            valueSize: sizeofValue(alignment).asUnsigned(),
                                                                            value: alignmentPointer),
                                                    CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.LineBreakMode,
                                                                            valueSize: sizeofValue(lineBreak).asUnsigned(),
                                                                            value: lineBreakPointer),
                                                    CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.LineSpacing,
                                                                            valueSize: sizeofValue(lineSpace).asUnsigned(),
                                                                            value: lineSpacePointer)
                                                    ]
        
        let paragraphStyle:CTParagraphStyleRef  = CTParagraphStyleCreate(_settings, UInt(_settings.count))

        CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle)
        CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font)
        CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTForegroundColorAttributeName, self.textColor.CGColor)
        
        CFRelease(paragraphStyle)
        CFRelease(font)
        
        let bounds:CGRect = rect
        var column:Integer
        let firstColumnRect:CGRect  = CGRectMake(0, 0, bounds.size.width / 2 - 20, bounds.size.height)
        let secondColumnRect:CGRect = CGRectMake(firstColumnRect.origin.x + firstColumnRect.size.width + 40,
                                                0,
                                                bounds.size.width - (firstColumnRect.origin.x + firstColumnRect.size.width + 40),
                                                bounds.size.height)
        
        let columnRectangles:CGRect[]   = [firstColumnRect, secondColumnRect]
        let array:CFMutableArrayRef     = CFArrayCreateMutable(kCFAllocatorDefault, 2, &kCFTypeArrayCallBacks)
        
        for column in 0..1 {
            
            let path:CGMutablePathRef = CGPathCreateMutable()
            let buffer:Any = path
            let pointer4:CConstVoidPointer = buffer as CConstVoidPointer
            
            CGPathAddRect(path, nil, columnRectangles[column])
            CFArrayInsertValueAtIndex(array, column, pointer4)
            CFRelease(path)
        }

        // TO DO !!!
        //free(columnRectangles);
        
        let context:CGContextRef  = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.bounds.size.height)
        CGContextScaleCTM(context, 1, -1)
        CGContextSetCharacterSpacing(context, 30.0)

        let frameSetter:CTFramesetterRef = CTFramesetterCreateWithAttributedString(attrStr)
        
        let pathCount:CFIndex = CFArrayGetCount(array)
        var startIndex:CFIndex = 0
        for column in 0..pathCount {
            
            let item:Any = CFArrayGetValueAtIndex(array, column)
            let path:CGPathRef  = item as CGPathRef
            let frame:CTFrameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(startIndex, 0), path, nil)
            CTFrameDraw(frame, context)
            let frameRange:CFRange  = CTFrameGetVisibleStringRange(frame)
            startIndex += frameRange.length
            CFRelease(frame)
        }

        CFRelease(array)
        CFRelease(frameSetter)
        CFRelease(attrStr)
        CFRelease(stringRef)
        CFRelease(fontName)
    }
*/
}
