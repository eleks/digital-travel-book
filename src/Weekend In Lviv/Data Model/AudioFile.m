//
//  AudioFile.m
//  Weekend In Lviv
//
//  Created by Vitaliy Gudenko on 2/21/13.
//  Copyright (c) 2013 Eleks Ltd. All rights reserved.
//

#import "AudioFile.h"
#import "Place.h"


@implementation AudioFile


@dynamic locale;
@dynamic path;
@dynamic place;

- (NSString *)text {
    return self.path;
}


@end
