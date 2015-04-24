//
//  ScenicMapManager.m
//  SliceDemo
//
//  Created by Sword Zhou on 5/14/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ScenicMapManager.h"

@implementation ScenicMapManager

- (BOOL)isMapDataAvailable:(MapLevel)level
{
    return TRUE;
}

- (Map*)getMapWithLevel:(MapLevel)level
{
    return nil;
}

- (MapSlice*)getMapSliceWithLevelAndPosition:(MapLevel)level row:(NSInteger)row col:(NSInteger)col
{
    return nil;
}

- (ScenicMap*)getScenicMapByMapLevel:(MapLevel)level
{
    return nil;
}
@end
