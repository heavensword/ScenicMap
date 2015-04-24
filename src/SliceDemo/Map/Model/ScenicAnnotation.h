//
//  Scenic.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/16/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ITTBaseModelObject.h"
#import <CoreLocation/CoreLocation.h>

@interface ScenicAnnotation : ITTBaseModelObject

@property (nonatomic, retain) NSString *name;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSString *thumbnailsLocalPath;

@end
