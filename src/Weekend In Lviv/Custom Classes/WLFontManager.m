//
//  WLFontManager.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/12/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "WLFontManager.h"


@interface WLFontManager (
private)


- (void)initFonts;

@end


@implementation WLFontManager


static WLFontManager *sharedManager = nil;


+ (WLFontManager *)sharedManager {
    static dispatch_once_t predicate = 0;
    __strong static id sharedManager = nil;
    dispatch_once(&predicate, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (id)init {
    self = [super init];
    if (self) {
        [self initFonts];
    }
    return self;
}


- (void)initFonts {
    self.bebasRegular11 = [UIFont fontWithName:@"Bebas Neue" size:11];
    self.bebasRegular12 = [UIFont fontWithName:@"Bebas Neue" size:12];
    self.bebasRegular16 = [UIFont fontWithName:@"Bebas Neue" size:16];
    self.bebasRegular20 = [UIFont fontWithName:@"Bebas Neue" size:20];
    self.bebasRegular21 = [UIFont fontWithName:@"Bebas Neue" size:21];
    self.bebasRegular22 = [UIFont fontWithName:@"Bebas Neue" size:22];
    self.bebasRegular32 = [UIFont fontWithName:@"Bebas Neue" size:32];
    self.bebasRegular36 = [UIFont fontWithName:@"Bebas Neue" size:36];
    self.bebasRegular44 = [UIFont fontWithName:@"Bebas Neue" size:44];
    self.bebasRegular100 = [UIFont fontWithName:@"Bebas Neue" size:100];
    self.bebasRegular120 = [UIFont fontWithName:@"Bebas Neue" size:120];

    self.gentiumRegular12 = [UIFont fontWithName:@"Gentium Book Basic" size:12];
    self.gentiumItalic15 = [UIFont fontWithName:@"GentiumBookBasic-Italic" size:15];
    self.gentiumItalic20 = [UIFont fontWithName:@"GentiumBookBasic-Italic" size:20];
    self.gentiumRegular16 = [UIFont fontWithName:@"Gentium Book Basic" size:16];

    self.palatinoItalic15 = [UIFont fontWithName:@"PalatinoLinotype-Italic" size:15];
    self.palatinoItalic20 = [UIFont fontWithName:@"PalatinoLinotype-Italic" size:20];
    self.palatinoItalic40 = [UIFont fontWithName:@"PalatinoLinotype-Italic" size:40];
    self.palatinoRegular12 = [UIFont fontWithName:@"PalatinoLinotype-Roman" size:12];
    self.palatinoRegular17 = [UIFont fontWithName:@"PalatinoLinotype-Roman" size:17];
    self.palatinoRegular34 = [UIFont fontWithName:@"PalatinoLinotype-Roman" size:34];
    self.palatinoRegular20 = [UIFont fontWithName:@"PalatinoLinotype-Roman" size:20];
}

@end
