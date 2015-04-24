//
//  MapSlice.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/13/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import "ScenicMap.h"

@interface MapSlice : ITTBaseModelObject
{
}

@property (nonatomic, assign) NSInteger identifier;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger col;

@property (nonatomic, assign) MapLevel level;

@property (nonatomic, retain) NSString *imageLocalPath;

@end
