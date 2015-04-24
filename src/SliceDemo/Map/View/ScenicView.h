//
//  SliceView.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/10/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Map.h"

@class ScenicMapView;
@class ScenicMap;

@interface ScenicView : UIView

@property (nonatomic, assign) ScenicMapView *scenicMapView;
@property (nonatomic, retain) ScenicMap *scenicMap;

- (id)initWithScenicMap:(ScenicMap*)scenicMap;

- (MapLevel)getMapLevel:(CGFloat)scale;

@end
