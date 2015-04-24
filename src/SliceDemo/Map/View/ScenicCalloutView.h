//
//  ScenicCalloutView.h
//  ScenicMapDemo
//
//  Created by Sword Zhou on 5/22/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScenicAnnotation;

@interface ScenicCalloutView : UIView

@property (nonatomic, assign) BOOL visible;

@property (nonatomic, retain) NSString *reuseIdentifier;
@property (nonatomic, retain) ScenicAnnotation *scenic;

+ (id)viewFromNibWithReuseIdentifier:(NSString*)reuseIdentifier;

- (void)displayDefaultCalloutAnimation;

- (void)hide;

@end
