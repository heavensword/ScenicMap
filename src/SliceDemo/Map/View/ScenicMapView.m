//
//  SliceScrollView.m
//  SliceDemo
//
//  Created by Sword Zhou on 5/10/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ScenicMapView.h"
#import "ScenicView.h"
#import "MapSlice.h"
#import "Map.h"
#import "ScenicAnnotation.h"
#import "ScenicAnnotationLayout.h"
#import "ScenicAnnotationView.h"
#import "ScenicMapManager.h"
#import "ScenicCalloutView.h"

#define DEFAULT_ANNOTATION_WIDTH     22
#define DEFAULT_ANNOTATION_HEIGHT    29

#define DEFAULT_ANNOTATION_CALLOUT_WIDTH     76
#define DEFAULT_ANNOTATION_CALLOUT_HEIGHT    51

@interface ScenicMapView()<UIScrollViewDelegate>
{
    BOOL                    _relayouting;
    MapLevel                _currentLevel;
    CGFloat                 _mapScale;

    CLLocationCoordinate2D  _leftTopCoordinate;
    CLLocationCoordinate2D  _rightBottomCoordinate;
    
    NSMutableSet            *_scenicsSet;
    NSMutableSet            *_visibleScenicLayouts;
    NSMutableSet            *_recyledScenicLayouts;
    NSMutableSet            *_visibleScenicCalloutLayouts;
    NSMutableSet            *_recyledScenicCalloutLayouts;    
    NSMutableSet            *_scenicLayouts;
    
    NSCache                 *_recycledViewsCache;
    
    ScenicMapManager        *_scenicMapManager;
}

@property (nonatomic, retain) ScenicView *oldScenicView;
@property (nonatomic, retain) ScenicView *scenicView;

@end

@implementation ScenicMapView

@synthesize scenicMap = _scenicMap;

#pragma mark - lifecycle
- (void)dealloc
{
    [_visibleScenicCalloutLayouts release];
    _visibleScenicCalloutLayouts = nil;
    [_recyledScenicCalloutLayouts release];
    _recyledScenicCalloutLayouts = nil;
    [_visibleScenicLayouts release];
    _visibleScenicLayouts = nil;
    [_recyledScenicLayouts release];
    _recyledScenicLayouts = nil;
    [_scenicsSet release];
    _scenicsSet = nil;
    _scenicMapManager = nil;
    [_scenicMap release];
    _scenicMap = nil;
    [_scenicView release];
    _scenicView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame map:(ScenicMap*)map
{
    self = [super initWithFrame:frame];
    if (self) {
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        self.scenicMap = map;
        _scenicView = [[ScenicView alloc] initWithScenicMap:self.scenicMap];
        _scenicView.scenicMapView = self;
        self.contentSize = self.scenicMap.mapSize;
        [self addSubview:_scenicView];
        [self setMaxMinZoomScalesForCurrentBounds];
        
        _currentLevel = [self.scenicView getMapLevel:self.zoomScale];
        _scenicMapManager = [ScenicMapManager sharedInstance];
        _leftTopCoordinate = CLLocationCoordinate2DMake(39.123456, 116.98278);
        _rightBottomCoordinate = CLLocationCoordinate2DMake(37.123456, 118.98278);
        _scenicsSet = [[NSMutableSet alloc] init];
        _visibleScenicLayouts = [[NSMutableSet alloc] init];
        _recyledScenicLayouts = [[NSMutableSet alloc] init];
        _visibleScenicCalloutLayouts = [[NSMutableSet alloc] init];
        _recyledScenicCalloutLayouts = [[NSMutableSet alloc] init];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        tapGestureRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    return self;
}

// Use layoutSubviews to center the PDF page in the view.
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.scenicView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        frameToCenter.origin.y = 0;
    }
    self.scenicView.frame = frameToCenter;
    
    if ([self.scenicView isKindOfClass:[ScenicView class]]) {
        // to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
        // tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
        // which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
        self.scenicView.contentScaleFactor = 1.0;
    }
}

- (void)handleTap:(UITapGestureRecognizer*)tapGestureRecognizer
{
    ITTDINFO(@"- (void)handleTap:(UITapGestureRecognizer*)tapGestureRecognizer");
    _currentLevel++;
    CGFloat scale = 1.0;
    if (_currentLevel < self.scenicMap.levelRange) {
        switch (_currentLevel) {
            case MapLevel1:
                scale = 0.125;
                break;
            case MapLevel2:
                scale = 0.25;
                break;
            case MapLevel3:
                scale = 0.5;
                break;
            case MapLevel4:
                scale = 1.0;
                break;
            default:
                break;
        }
    }
    CGSize contentSize = CGSizeMake(self.scenicMap.mapSize.width * scale, self.scenicMap.mapSize.height * scale);
    [self setContentSize:contentSize];
    CGRect frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - public methods

#pragma mark - private methods
- (BOOL)isMapLevelDidChanged:(CGFloat)scale
{
    MapLevel level = [self.scenicView getMapLevel:scale];
    return level != _currentLevel;
}

- (void)setMaxMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    CGSize mapSize = self.scenicMap.mapSize;
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / mapSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / mapSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale) {
        minScale = maxScale;
    }    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = self.minimumZoomScale;
}

- (CGRect)visibleMapRect
{
    return CGRectMake(self.contentOffset.x, self.contentOffset.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view
{
    CGFloat latitudeRangeDelta = fabsf(_rightBottomCoordinate.latitude - _leftTopCoordinate.latitude);
    CGFloat longitudeRangeDelta = fabsf(_rightBottomCoordinate.longitude - _leftTopCoordinate.longitude);
    CGFloat latitudeDelta = fabsf(coordinate.latitude - _leftTopCoordinate.latitude);
    CGFloat longitudeDelta = fabsf(coordinate.longitude - _leftTopCoordinate.longitude);
    CGSize size = self.contentSize;
    CGFloat x = (longitudeDelta/longitudeRangeDelta) * size.width;
    CGFloat y = (latitudeDelta/latitudeRangeDelta) * size.height;
    if (CGRectGetHeight(self.scenicView.frame) < CGRectGetHeight(self.frame)) {
        y += (CGRectGetHeight(self.frame) - CGRectGetHeight(self.scenicView.frame))/2;
    }
    if (CGRectGetWidth(self.scenicView.frame) < CGRectGetWidth(self.frame)) {
        x += (CGRectGetWidth(self.frame) - CGRectGetWidth(self.scenicView.frame))/2;
    }
    ITTDINFO(@"width %f", size.width);
    return CGPointMake(x, y);
}

- (CGRect)getScenicRect:(CLLocationCoordinate2D)coordinate
{
    CGPoint origin = [self convertCoordinate:coordinate toPointToView:self];
    CGRect rect = CGRectMake(origin.x, origin.y, DEFAULT_ANNOTATION_WIDTH, DEFAULT_ANNOTATION_HEIGHT);
    return rect;
}

- (CGRect)getCalloutFrame:(CGRect)annotationViewFrame originCalloutFrame:(CGRect)originCalloutFrame
{
    if (CGRectEqualToRect(CGRectZero, originCalloutFrame)) {
        originCalloutFrame = CGRectMake(0, 0, DEFAULT_ANNOTATION_CALLOUT_WIDTH, DEFAULT_ANNOTATION_CALLOUT_HEIGHT);
    }
    CGFloat marginX = CGRectGetMinX(annotationViewFrame) + (CGRectGetWidth(annotationViewFrame) - CGRectGetWidth(originCalloutFrame))/2;
    CGFloat marginY = CGRectGetMinY(annotationViewFrame) - CGRectGetHeight(originCalloutFrame);
    CGFloat width = CGRectGetWidth(originCalloutFrame);
    CGFloat height = CGRectGetHeight(originCalloutFrame);
    CGRect calloutFrame = CGRectMake(marginX, marginY, width, height);
    return calloutFrame;
}

- (void)addScenic:(ScenicAnnotation*)scenic
{
    [self addScenic:scenic reload:TRUE];
}

- (void)addScenic:(ScenicAnnotation*)scenic reload:(BOOL)reload
{
    NSAssert(!(scenic == nil), @"nil scenic object!");
    if (!_scenicsSet) {
        _scenicsSet = [[NSMutableSet alloc] init];
    }
    [_scenicsSet addObject:scenic];
    ScenicAnnotationLayout *scenicLayout = [[ScenicAnnotationLayout alloc] init];
    scenicLayout.scenic = scenic;
    scenicLayout.rect = [self getScenicRect:scenic.coordinate];
    if (!_scenicLayouts) {
        _scenicLayouts = [[NSMutableSet alloc] init];
    }
    [_scenicLayouts addObject:scenicLayout];
    [scenicLayout release];
    if (reload) {
        [self reloadScenicAnnotationViews];        
    }
}

- (void)addScenics:(NSArray*)scenics
{
    if (scenics && [scenics count]) {
        for (ScenicAnnotation *scenic in scenics) {
            [self addScenic:scenic reload:FALSE];
        }
        [self reloadScenicAnnotationViews];        
    }
}

- (void)removeScenic:(ScenicAnnotation*)scenic reload:(BOOL)reload
{
    [_scenicsSet removeObject:scenic];
    ScenicAnnotationLayout *removedScenicLayout = nil;
    for (ScenicAnnotationLayout *scenicLayout in _scenicLayouts) {
        if (scenic == scenicLayout.scenic) {
            removedScenicLayout = scenicLayout;
            break;
        }
    }
    if (removedScenicLayout) {
        [_scenicLayouts removeObject:removedScenicLayout];
        [self recyleScenicAnnotationView:removedScenicLayout];
        [self recyleScenicCalloutView:removedScenicLayout];
    }
    if (reload) {
        [self reloadScenicAnnotationViews];        
    }
}

- (void)removeScenic:(ScenicAnnotation*)scenic
{
    if (scenic) {
        [self removeScenic:scenic reload:TRUE];
    }
}

- (void)removeScenics:(NSArray*)scenics
{
    if (scenics && [scenics count]) {
        for (ScenicAnnotation *scenic in scenics) {
            [self removeScenic:scenic reload:FALSE];
        }
        [self reloadScenicAnnotationViews];        
    }
}

- (void)removeAllScenics
{
    [_scenicsSet removeAllObjects];
    for (ScenicAnnotationLayout *scenicLayout in _scenicLayouts) {
        [self recyleScenicAnnotationView:scenicLayout];
    }
    [_scenicLayouts removeAllObjects];
    [self reloadScenicAnnotationViews];
}

- (BOOL)isAreaVisible:(CGRect)rect
{
    CGRect visibleRect = [self visibleMapRect];
    CGRect intersectionRect = CGRectIntersection(rect, visibleRect);
    BOOL visible = !CGRectIsNull(intersectionRect);
    return visible;
}

- (ScenicAnnotationLayout*)getAnnotationLayout:(ScenicAnnotation*)scenic
{
    ScenicAnnotationLayout *layout = nil;
    for (ScenicAnnotationLayout *scenicAnnotationLayout in _scenicLayouts) {
        if (scenicAnnotationLayout.scenic == scenic) {
            layout = scenicAnnotationLayout;
            break;
        }
    }
    return layout;
}

- (void)handleCallout:(ScenicAnnotationView*)annotationView
{
    ITTDINFO(@"- (void)showCalloutView:(ScenicAnnotationView*)annotationView");
    ScenicAnnotationLayout *scenicAnnotationLayout = [self getAnnotationLayout:annotationView.scenic];
    ScenicCalloutView *scenicCalloutView = nil;
    if (scenicAnnotationLayout) {
        scenicCalloutView = scenicAnnotationLayout.scenicCalloutView;
    }
    if (!scenicCalloutView) {
        if (_mapDelegate && [_mapDelegate respondsToSelector:@selector(scenicMapView:calloutViewForAnnotation:)]) {
            scenicCalloutView = [_mapDelegate scenicMapView:self calloutViewForAnnotation:annotationView.scenic];
        }
        if (!scenicCalloutView) {
            scenicCalloutView = [ScenicCalloutView viewFromNibWithReuseIdentifier:@"ScenicCalloutView"];
            scenicCalloutView.scenic = scenicAnnotationLayout.scenic;
        }        
    }
    scenicAnnotationLayout.callOutRect = [self getCalloutFrame:annotationView.frame originCalloutFrame:scenicCalloutView.frame];
    scenicCalloutView.frame = scenicAnnotationLayout.callOutRect;
    if (!scenicCalloutView.visible) {
        scenicAnnotationLayout.scenicCalloutView = scenicCalloutView;
        [self addSubview:scenicCalloutView];
    }
    else {
        [self bringSubviewToFront:scenicCalloutView];
    }
    [scenicCalloutView displayDefaultCalloutAnimation];    
    if (scenicCalloutView && scenicAnnotationLayout) {
        scenicAnnotationLayout.scenicCalloutView = scenicCalloutView;
        scenicAnnotationLayout.hasCalloutView = TRUE;
    }
}

- (void)recyleScenicAnnotationView:(ScenicAnnotationLayout*)scenicLayout
{
    if (scenicLayout.scenicAnnotationView) {
        ScenicAnnotationView *scenicAnnotationView = scenicLayout.scenicAnnotationView;
        NSString *identifier = scenicAnnotationView.reuseIdentifier;
        NSMutableSet *_recycledViews = [_recycledViewsCache objectForKey:identifier];
        [_recycledViews addObject:scenicAnnotationView];
        [scenicAnnotationView removeFromSuperview];
    }
    scenicLayout.scenicAnnotationView = nil;
    scenicLayout.visible = FALSE;
}

- (void)recyleScenicCalloutView:(ScenicAnnotationLayout*)scenicLayout
{
    if (scenicLayout.scenicCalloutView) {
        ScenicCalloutView *scenicCalloutView = scenicLayout.scenicCalloutView;
        NSString *identifier = scenicCalloutView.reuseIdentifier;
        NSMutableSet *_recycledViews = [_recycledViewsCache objectForKey:identifier];
        [_recycledViews addObject:scenicCalloutView];
        [scenicCalloutView removeFromSuperview];
    }
    scenicLayout.scenicCalloutView = nil;
}

- (void)recyleInvisibleAnnotationViews
{
    if (!_recyledScenicLayouts) {
        _recyledScenicLayouts = [[NSMutableSet alloc] init];
    }
    for (ScenicAnnotationLayout *scenicLayout in _visibleScenicLayouts) {
        if (![self isAreaVisible:scenicLayout.rect]) {
            ITTDINFO(@"recyle!");
            [self recyleScenicAnnotationView:scenicLayout];
            [_recyledScenicLayouts addObject:scenicLayout];
        }
    }
    [_visibleScenicLayouts minusSet:_recyledScenicLayouts];
}

- (void)layoutVisibleAnnotationViews
{
    for (ScenicAnnotationLayout *scenicLayout in _scenicLayouts) {
        if ([self isAreaVisible:scenicLayout.rect]) {
            ITTDINFO(@"visible!");
            scenicLayout.visible = TRUE;
            ScenicAnnotationView *scenicAnnotationView = scenicLayout.scenicAnnotationView;
            if (!scenicAnnotationView) {
                scenicAnnotationView = [_mapDelegate scenicMapView:self viewForAnnotation:scenicLayout.scenic];
            }
            if (!scenicAnnotationView) {
                scenicAnnotationView = [[ScenicAnnotationView alloc] initWithScenic:scenicLayout.scenic reuseIdentifier:@"ScenicAnnotationView"];
            }
            [scenicAnnotationView setOnHandleTapBlock:^(ScenicAnnotationView *scenicAnnotationView) {
                [self handleCallout:scenicAnnotationView];
            }];
            scenicLayout.scenicAnnotationView = scenicAnnotationView;
            if (!scenicLayout.hasDrawnInMap) {
                scenicLayout.hasDrawnInMap = TRUE;
                [self addSubview:scenicAnnotationView];
            }
            scenicAnnotationView.scenic = scenicLayout.scenic;
            scenicAnnotationView.frame = scenicLayout.rect;            
            [_visibleScenicLayouts addObject:scenicLayout];
        }
        else {
            ITTDINFO(@"not invisible!");
            scenicLayout.visible = FALSE;
            scenicLayout.hasDrawnInMap = FALSE;
        }
    }
}

- (void)recyleInvisibleCalloutViews
{
    if (!_recyledScenicCalloutLayouts) {
        _recyledScenicCalloutLayouts = [[NSMutableSet alloc] init];
    }
    for (ScenicAnnotationLayout *scenicLayout in _visibleScenicCalloutLayouts) {
        if (![self isAreaVisible:scenicLayout.callOutRect]) {
            [self recyleScenicCalloutView:scenicLayout];
            [_recyledScenicCalloutLayouts addObject:scenicLayout];
        }
    }
    [_visibleScenicCalloutLayouts minusSet:_recyledScenicCalloutLayouts];
}

- (void)layoutVisibleCalloutViews
{
    for (ScenicAnnotationLayout *scenicLayout in _scenicLayouts) {
        if (scenicLayout.hasCalloutView) {
            ITTDINFO(@"has!");
            if ([self isAreaVisible:scenicLayout.callOutRect]) {
                ScenicCalloutView *scenicCalloutView = scenicLayout.scenicCalloutView;
                if (!scenicCalloutView) {
                    scenicCalloutView = [_mapDelegate scenicMapView:self calloutViewForAnnotation:scenicLayout.scenic];
                }
                if (!scenicCalloutView) {
                    scenicCalloutView = [ScenicCalloutView viewFromNibWithReuseIdentifier:@"ScenicCalloutView"];
                }
                scenicLayout.scenicCalloutView = scenicCalloutView;
                scenicCalloutView.frame = scenicLayout.callOutRect;
                [self addSubview:scenicCalloutView];
                [_visibleScenicCalloutLayouts addObject:scenicLayout];
            }
        }
    }
}

- (void)caculateLayoutPosition
{
    for (ScenicAnnotationLayout *scenicLayout in _scenicLayouts) {
        scenicLayout.rect = [self getScenicRect:scenicLayout.scenic.coordinate];
        scenicLayout.callOutRect = [self getCalloutFrame:scenicLayout.rect originCalloutFrame:scenicLayout.callOutRect];
    }
}

- (void)reloadScenicAnnotationViews
{
    if (!_relayouting) {
        _relayouting = TRUE;
        [self caculateLayoutPosition];
        
        [self recyleInvisibleAnnotationViews];
        [self recyleInvisibleCalloutViews];
        
        [self layoutVisibleAnnotationViews];
        [self layoutVisibleCalloutViews];        
        _relayouting = FALSE;
    }
}

- (ScenicAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier
{
    NSMutableSet *_recycledViews = [_recycledViewsCache objectForKey:identifier];
    ScenicAnnotationView *scenicAnnotationView = [[[_recycledViews anyObject] retain] autorelease];
    if (scenicAnnotationView) {
        [_recycledViews removeObject:scenicAnnotationView];
    }
    return scenicAnnotationView;
}

- (ScenicCalloutView *)dequeueReusableCalloutViewWithIdentifier:(NSString *)identifier
{
    NSMutableSet *_recycledViews = [_recycledViewsCache objectForKey:identifier];
    ScenicCalloutView *calloutView = [[[_recycledViews anyObject] retain] autorelease];
    if (calloutView) {
        [_recycledViews removeObject:calloutView];
    }
    return calloutView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self reloadScenicAnnotationViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

/*
 * A UIScrollView delegate callback, called when the user starts zooming.
 * Return the current ScenicView.
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _scenicView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    ITTDINFO(@"- (void)scrollViewDidZoom:(UIScrollView *)scrollView");
    [self reloadScenicAnnotationViews];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [self reloadScenicAnnotationViews];
    ITTDINFO(@"- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale %f", scale);
    if ([self isMapLevelDidChanged:scale]) {
        _currentLevel = [self.scenicView getMapLevel:scale];
        if ([_scenicMapManager isMapDataAvailable:_currentLevel]) {
            Map *map = [_scenicMapManager getMapWithLevel:_currentLevel];
            [self.scenicMap addMap:map level:_currentLevel];
        }
        else {
            if (_mapDelegate && [_mapDelegate respondsToSelector:@selector(scenicMapViewDidNeedRequestMapData:scenicMap:level:)]) {
                [_mapDelegate scenicMapViewDidNeedRequestMapData:self scenicMap:self.scenicMap level:_currentLevel];
            }
        }
    }    
    //notify delegate about current zoom level
    if (_mapDelegate && [_mapDelegate respondsToSelector:@selector(scenicMapViewDidZoomLevel:level:)]) {
        [_mapDelegate scenicMapViewDidZoomLevel:self level:[self.scenicView getMapLevel:scale]];
    }
}

@end
