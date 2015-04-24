//
//  ScenicMapManager.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/14/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "Manager.h"
#import "Map.h"
#import "ScenicMap.h"

@interface ScenicMapManager : Manager

- (BOOL)isMapDataAvailable:(MapLevel)level;

- (Map*)getMapWithLevel:(MapLevel)level;

- (MapSlice*)getMapSliceWithLevelAndPosition:(MapLevel)level row:(NSInteger)row col:(NSInteger)col;

- (ScenicMap*)getScenicMapByMapLevel:(MapLevel)level;

@end
