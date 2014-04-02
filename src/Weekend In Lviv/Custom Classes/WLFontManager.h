//
//  WLFontManager.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/12/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WLFontManager : NSObject


+ (WLFontManager *)sharedManager;

@property (strong, nonatomic) UIFont *bebasRegular11;
@property (strong, nonatomic) UIFont *bebasRegular12;
@property (strong, nonatomic) UIFont *bebasRegular16;
@property (strong, nonatomic) UIFont *bebasRegular20;
@property (strong, nonatomic) UIFont *bebasRegular21;
@property (strong, nonatomic) UIFont *bebasRegular22;
@property (strong, nonatomic) UIFont *bebasRegular32;
@property (strong, nonatomic) UIFont *bebasRegular36;
@property (strong, nonatomic) UIFont *bebasRegular44;
@property (strong, nonatomic) UIFont *bebasRegular100;
@property (strong, nonatomic) UIFont *bebasRegular120;


@property (strong, nonatomic) UIFont *gentiumRegular12;
@property (strong, nonatomic) UIFont *gentiumRegular16;
@property (strong, nonatomic) UIFont *gentiumItalic15;
@property (strong, nonatomic) UIFont *gentiumItalic20;

@property (strong, nonatomic) UIFont *palatinoItalic15;
@property (strong, nonatomic) UIFont *palatinoItalic20;
@property (strong, nonatomic) UIFont *palatinoItalic40;
@property (strong, nonatomic) UIFont *palatinoRegular12;
@property (strong, nonatomic) UIFont *palatinoRegular17;
@property (strong, nonatomic) UIFont *palatinoRegular34;
@property (strong, nonatomic) UIFont *palatinoRegular20;

@end
