//
//  ScenicMap.m
//  SliceDemo
//
//  Created by Sword Zhou on 5/14/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ScenicMap.h"
#import "MapSlice.h"

@interface ScenicMap()

@property (nonatomic, retain) NSMutableDictionary *mapsDic;
@end

@implementation ScenicMap


- (void)dealloc
{
    [_mapsDic release];
    _mapsDic = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _mapsDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString*)getMapKey:(MapLevel)level
{
    return [NSString stringWithFormat:@"map_key%d", level];
}

- (void)addMap:(Map*)map level:(MapLevel)level
{
    if (map) {
        NSString *key = [self getMapKey:level];
        _mapsDic[key] = map;
    }
}

- (Map*)getMapWithLevel:(MapLevel)level
{
    NSString *key = [self getMapKey:level];
    Map *map = _mapsDic[key];
    return map;
}

- (MapSlice*)getMapSliceWithLevelAndPosition:(MapLevel)level row:(NSInteger)row col:(NSInteger)col
{
    MapSlice *mapSlice = nil;
    NSString *mapKey = [self getMapKey:level];
    Map *levelMap = _mapsDic[mapKey];
    NSArray *mapSlices = levelMap.mapSlices;
    if (mapSlices) {
        for (MapSlice *slice in mapSlices) {
            if (slice.row == row && slice.col == col &&
                slice.level == level) {
                mapSlice = slice;
                break;
            }
        }
    }
    return mapSlice;
}

@end
