//
//  ScenicMap.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/14/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "Map.h"

@class MapSlice;

@interface ScenicMap : ITTBaseModelObject

@property (nonatomic, assign) NSInteger levelRange;
@property (nonatomic, assign) CGSize mapSize;

- (void)addMap:(Map*)map level:(MapLevel)level;

- (Map*)getMapWithLevel:(MapLevel)level;

- (MapSlice*)getMapSliceWithLevelAndPosition:(MapLevel)level row:(NSInteger)row col:(NSInteger)col;

@end
