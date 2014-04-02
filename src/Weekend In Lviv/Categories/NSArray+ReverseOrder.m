//
// Created by Viktor Malieichyk on 3/19/14.
// Copyright (c) 2014 Eleks Ltd.. All rights reserved.
//

#import "NSArray+ReverseOrder.h"


@implementation NSArray (ReverseOrder)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end