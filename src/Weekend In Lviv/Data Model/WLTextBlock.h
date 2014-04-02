//
//  WLTextBlock.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/18/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WLTextBlock : NSObject


@property (strong, nonatomic) NSString *blockTitle;
@property (strong, nonatomic) NSString *blockSubtitle;
@property (strong, nonatomic) NSString *blockText;
@property (strong, nonatomic) NSArray *blockImagesPath;

@end
