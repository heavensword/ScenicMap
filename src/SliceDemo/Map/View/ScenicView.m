//
//  SliceView.m
//  SliceDemo
//
//  Created by Sword Zhou on 5/10/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIDevice+ITTAdditions.h"
#import "ScenicView.h"
#import "MapSlice.h"
#import "ScenicMapSliceView.h"
#import "ScenicMapView.h"

@interface ScenicView()
{
}
@end

@implementation ScenicView

@synthesize scenicMap = _scenicMap;

#pragma mark - private methods
- (void)setup
{
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    tiledLayer.levelsOfDetail = self.scenicMap.levelRange;
}

#pragma mark - lifecycle
- (void)dealloc
{
    _scenicMapView = nil;
    [_scenicMap release];
    _scenicMap = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithScenicMap:(ScenicMap*)scenicMap
{
    CGSize mapSize = scenicMap.mapSize;
    self = [super initWithFrame:CGRectMake(0, 0, mapSize.width, mapSize.height)];
    if (self) {
        self.scenicMap = scenicMap;
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

+ (Class)layerClass
{
    return [CATiledLayer class];
}

- (MapLevel)getMapLevel:(CGFloat)scale
{
    MapLevel level = MapLevel1;
    NSInteger scaleIntValue = (NSInteger)(scale * 1000);
    if (scaleIntValue <= 125) {
        level = MapLevel1;
    }
    else if (scaleIntValue > 125 && scaleIntValue <= 250) {
        level = MapLevel2;
    }
    else if (scaleIntValue > 250 && scaleIntValue <= 500) {
        level = MapLevel3;
    }
    else if (scaleIntValue > 500 && scaleIntValue <= 1000) {
        level = MapLevel4;
    }
    return level;
}

- (void)layoutSubviews
{
}

- (void)drawRect:(CGRect)rect
{
    ITTDINFO(@"drawRect x %f y %f width %f height %f", CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
 	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // get the scale from the context by getting the current transform matrix, then asking for
    // its "a" component, which is one of the two scale components. We could also ask for "d".
    // This assumes (safely) that the view is being scaled equally in both dimensions.
    CGFloat scale = CGContextGetCTM(context).a;
    
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    CGSize tileSize = tiledLayer.tileSize;
    
    tileSize.width /= scale;
    tileSize.height /= scale;
    
    // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
    int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
    int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);

    ITTDINFO(@"scale %f level %d", scale, [self getMapLevel:scale]);
    
    for (int row = firstRow; row <= lastRow; row++) {
        for (int col = firstCol; col <= lastCol; col++) {
            MapSlice *mapSlice = [self.scenicMap getMapSliceWithLevelAndPosition:[self getMapLevel:scale] row:row col:col];
            NSString *path = mapSlice.imageLocalPath;
            UIImage *tile = [UIImage imageWithContentsOfFile:path];
            if (!tile) {
                tile = [UIImage imageNamed:@"slice_default.png"];
            }
            CGRect tileRect = CGRectMake(tileSize.width * col, tileSize.height * row,
                                         tileSize.width, tileSize.height);
            tileRect = CGRectIntersection(self.bounds, tileRect);
            [tile drawInRect:tileRect];
            
            //draw outline
//            [[UIColor whiteColor] set];
//            CGContextSetLineWidth(context, 2.0 / scale);
//            CGContextStrokeRect(context, tileRect);
        }
    }
}
@end
