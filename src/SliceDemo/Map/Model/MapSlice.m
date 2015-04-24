//
//  MapSlice.m
//  SliceDemo
//
//  Created by Sword Zhou on 5/13/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "MapSlice.h"

@implementation MapSlice

- (id)init
{
    self = [super init];
    if (self) {
        _identifier = NSNotFound;
    }
    return self;
}

- (NSDictionary*)attributeMapDictionary
{
    return @{@"x":@"block_x", @"y":@"block_y", @"width":@"block_w", @"height":@"block_h"};
}

@end
