//
//  Map.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/14/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ITTBaseModelObject.h"

typedef enum {
    MapLevel1 = 1,
    MapLevel2,
    MapLevel3,
    MapLevel4,
}MapLevel;

@class MapSlice;

@interface Map : ITTBaseModelObject

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, retain) NSArray *mapSlices;

@end

