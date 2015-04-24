//
//  ScenicMapViewDelegate.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/13/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"

@class ScenicMap;
@class ScenicMapView;
@class ScenicAnnotationView;
@class ScenicCalloutView;
@class ScenicAnnotation;

@protocol ScenicMapViewDataSource <NSObject>
@required
@end

@protocol ScenicMapViewDelegate <NSObject>
@optional

- (void)scenicMapViewDidZoomLevel:(ScenicMapView*)scenicMapView level:(MapLevel)level;
- (void)scenicMapViewDidNeedRequestMapData:(ScenicMapView*)scenicMapView scenicMap:(ScenicMap*)scenicMap level:(MapLevel)level;

- (ScenicAnnotationView *)scenicMapView:(ScenicMapView*)mapView viewForAnnotation:(ScenicAnnotation*)scenic;
- (ScenicCalloutView *)scenicMapView:(ScenicMapView*)mapView calloutViewForAnnotation:(ScenicAnnotation*)scenic;

@end
