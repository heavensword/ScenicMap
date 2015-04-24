//
//  SliceScrollView.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/10/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ScenicMapViewDelegate.h"

@class ScenicMap;
@class ScenicAnnotation;
@class ScenicAnnotationView;
@class ScenicCalloutView;

@interface ScenicMapView : UIScrollView

@property (nonatomic, retain) ScenicMap *scenicMap;

@property (nonatomic, assign) IBOutlet id<ScenicMapViewDelegate> mapDelegate;

- (id)initWithFrame:(CGRect)frame map:(ScenicMap*)map;

- (void)addScenic:(ScenicAnnotation*)scenic;

- (void)addScenics:(NSArray*)scenics;

- (void)removeScenic:(ScenicAnnotation*)scenic;

- (void)removeScenics:(NSArray*)scenics;

- (void)removeAllScenics;

- (CGRect)visibleMapRect;

- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;

- (ScenicAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

- (ScenicCalloutView *)dequeueReusableCalloutViewWithIdentifier:(NSString *)identifier;

@end
