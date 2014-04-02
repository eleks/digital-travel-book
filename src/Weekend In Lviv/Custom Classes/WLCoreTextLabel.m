//
//  WLCoreTextLabel.m
//  CareTextLabel
//
//  Created by Vitaliy Gudenko on 2/28/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLCoreTextLabel.h"


@implementation WLCoreTextLabel


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {

    CFStringRef fontName = CFStringCreateWithCString(kCFAllocatorDefault, [self.font.fontName cStringUsingEncoding:NSUTF8StringEncoding], kCFStringEncodingUTF8);

    CFStringRef stringRef = CFStringCreateWithCString(kCFAllocatorDefault, [self.text cStringUsingEncoding:NSUTF8StringEncoding], kCFStringEncodingUTF8);
    CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString(attrStr, CFRangeMake(0, 0), stringRef);
    CTFontRef font = CTFontCreateWithName(fontName, self.font.pointSize, NULL);

    CTTextAlignment alignment = kCTLeftTextAlignment;
    CTLineBreakMode lineBreak = kCTLineBreakByWordWrapping;
    CGFloat lineSpace = 0;

    CTParagraphStyleSetting _settings[] = {{kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}, {kCTParagraphStyleSpecifierLineBreakMode, sizeof(lineBreak), &lineBreak}, {kCTParagraphStyleSpecifierLineSpacing, sizeof(lineSpace), &lineSpace}};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(_settings, sizeof(_settings) / sizeof(_settings[0]));

    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle);
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTForegroundColorAttributeName, self.textColor.CGColor);

    CFRelease(paragraphStyle);
    CFRelease(font);


    CGRect bounds = rect;
    int column;
    CGRect *columnRectangles = (CGRect *) calloc(2, sizeof(CGRect));
    CGRect firstColumnRect = CGRectMake(0, 0, bounds.size.width / 2 - 20, bounds.size.height);
    CGRect secondColumnRect = CGRectMake(firstColumnRect.origin.x + firstColumnRect.size.width + 40, 0, bounds.size.width - (firstColumnRect.origin.x + firstColumnRect.size.width + 40), bounds.size.height);
    columnRectangles[0] = firstColumnRect;
    columnRectangles[1] = secondColumnRect;
    CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault, 2, &kCFTypeArrayCallBacks);

    for (column = 0; column < 2; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRectangles[column]);
        CFArrayInsertValueAtIndex(array, column, path);
        CFRelease(path);
    }
    free(columnRectangles);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetCharacterSpacing(context, 30.0);

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(attrStr);

    CFIndex pathCount = CFArrayGetCount(array);
    CFIndex startIndex = 0;
    for (column = 0; column < pathCount; column++) {

        CGPathRef path = (CGPathRef) CFArrayGetValueAtIndex(array, column);
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }
    CFRelease(array);
    CFRelease(frameSetter);
    CFRelease(attrStr);
    CFRelease(stringRef);
    CFRelease(fontName);
}

@end
