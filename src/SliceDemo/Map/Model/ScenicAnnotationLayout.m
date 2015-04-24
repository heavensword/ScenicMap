//
//  ScenicLayout.m
//  ScenicMapDemo
//
//  Created by Sword Zhou on 5/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ScenicAnnotationLayout.h"

@implementation ScenicAnnotationLayout

@synthesize visible = _visible;
@synthesize rect = _rect;
@synthesize scenic = _scenic;
@synthesize hasDrawnInMap = _hasDrawnInMap;
@synthesize scenicCalloutView = _scenicCalloutView;
@synthesize scenicAnnotationView = _scenicAnnotationView;

- (id)init
{
    self = [super init];
    if (self) {
        _visible = FALSE;
        _hasDrawnInMap = FALSE;
        _rect = CGRectZero;
        _callOutRect = CGRectZero;
    }
    return self;
}

- (void)dealloc
{
    [_scenicCalloutView release];
    _scenicCalloutView = nil;
    [_scenic release];
    _scenic = nil;
    [_scenicAnnotationView release];
    _scenicAnnotationView = nil;
    [super dealloc];
}

@end
