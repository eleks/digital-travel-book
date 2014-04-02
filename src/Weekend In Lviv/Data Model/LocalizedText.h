//
//  LocalizedText.h
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/21/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Place, PointBlock, PointOfBlock, TextBlock;


@interface LocalizedText : NSManagedObject


@property (nonatomic, strong) NSString *locale;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) Place *placeText;
@property (nonatomic, strong) Place *placeTitle;
@property (nonatomic, strong) TextBlock *textBlockSubtitle;
@property (nonatomic, strong) TextBlock *textBlockText;
@property (nonatomic, strong) TextBlock *textBlockTitle;
@property (nonatomic, strong) PointBlock *pointBlockMainText;
@property (nonatomic, strong) PointOfBlock *pointText;

@end
