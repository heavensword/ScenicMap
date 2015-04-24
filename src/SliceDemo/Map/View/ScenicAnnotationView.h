//
//  ScenicAnnotationView.h
//  SliceDemo
//
//  Created by Sword Zhou on 5/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScenicAnnotation;

@interface ScenicAnnotationView : UIView


@property (nonatomic, retain) NSString *reuseIdentifier;
@property (nonatomic, retain) ScenicAnnotation *scenic;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, copy) void (^onHandleTapBlock)(ScenicAnnotationView*);

- (id)initWithScenic:(ScenicAnnotation*)scenic reuseIdentifier:(NSString*)reuseIdentifier;

@end
