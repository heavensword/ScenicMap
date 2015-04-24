//
//  ScenicLayout.h
//  ScenicMapDemo
//
//  Created by Sword Zhou on 5/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScenicAnnotation;
@class ScenicAnnotationView;
@class ScenicCalloutView;

@interface ScenicAnnotationLayout : NSObject

@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL hasCalloutView;
@property (nonatomic, assign) BOOL hasDrawnInMap;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGRect callOutRect;
@property (nonatomic, retain) ScenicAnnotation *scenic;
@property (nonatomic, retain) ScenicAnnotationView *scenicAnnotationView;
@property (nonatomic, retain) ScenicCalloutView *scenicCalloutView;

@end
