//
//  ScenicMapSliceView.m
//  SliceDemo
//
//  Created by Sword Zhou on 5/13/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ScenicMapSliceView.h"
#import "MapSlice.h"

@interface ScenicMapSliceView()
{
    UIImageView *_mapImageView;
}
@end

@implementation ScenicMapSliceView

@synthesize mapSlice = _mapSlice;

#pragma mark - private methods

#pragma mark - lifecycle
- (void)dealloc
{
    [_mapSlice release];
    _mapSlice = nil;
    [_mapImageView release];
    _mapImageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mapImageView = [[UIImageView alloc] initWithFrame:frame];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    if (!_mapImageView.superview) {
        _mapImageView.frame = self.bounds;
        [self addSubview:_mapImageView];
    }
    _mapImageView.image = [UIImage imageWithContentsOfFile:self.mapSlice.imageLocalPath];
}
@end
