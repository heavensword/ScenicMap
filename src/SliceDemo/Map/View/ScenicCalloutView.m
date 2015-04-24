//
//  ScenicCalloutView.m
//  ScenicMapDemo
//
//  Created by Sword Zhou on 5/22/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ScenicCalloutView.h"
#import "ScenicAnnotation.h"

@interface ScenicCalloutView()

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ScenicCalloutView

@synthesize visible = _visible;
@synthesize scenic = _scenic;
@synthesize reuseIdentifier = _reuseIdentifier;

- (void)handleTap:(UITapGestureRecognizer*)gestureRecognizer
{
    [self hide];
}

- (void)setup
{
    self.reuseIdentifier = NSStringFromClass([self class]);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
}

- (void)dealloc
{
    [_scenic release];
    _scenic = nil;
    [_reuseIdentifier release];
    _reuseIdentifier = nil;
    [_nameLabel release];
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

- (void)awakeFromNib
{
    [self setup];    
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    self.nameLabel.text = self.scenic.name;
    [super layoutSubviews];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CATransform3D)layerTransformForScale:(CGFloat)scale targetFrame:(CGRect)targetFrame
{
//	CGFloat horizontalDelta = targetFrame.size.width/2;
	CGFloat hotizontalScaleTransform = 1.0;//(horizontalDelta * scale) - horizontalDelta;
	
	CGFloat verticalDelta = roundf(targetFrame.size.height/2);
	CGFloat verticalScaleTransform = verticalDelta - (verticalDelta * scale);
	
	CGAffineTransform affineTransform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, hotizontalScaleTransform, verticalScaleTransform);
	return CATransform3DMakeAffineTransform(affineTransform);
}

// Popup animation for the selected callout.
- (void)displayDefaultCalloutAnimation
{
    _visible = TRUE;
	CGRect targetFrame = self.bounds;
	self.layer.transform = [self layerTransformForScale:0.001f targetFrame:targetFrame];
	
	[UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionLayoutSubviews
					 animations:^{
						 self.layer.transform = [self layerTransformForScale:1.1f targetFrame:targetFrame];
					 }
					 completion:^ (BOOL finished) {
						 [UIView animateWithDuration:0.1
											   delay:0
											 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionLayoutSubviews
										  animations:^{
											  self.layer.transform = [self layerTransformForScale:0.95f targetFrame:targetFrame];
										  }
										  completion:^ (BOOL finished) {
											  [UIView animateWithDuration:0.1
																	delay:0
																  options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionLayoutSubviews
															   animations:^{
																   self.layer.transform = [self layerTransformForScale:1.0f targetFrame:targetFrame];
															   }
															   completion:^ (BOOL finished) {
																   self.layer.transform = CATransform3DIdentity;
															   }
											   ];
										  }];
					 }
	 ];
}

- (void)hide
{
    _visible = FALSE;
    [self removeFromSuperview];
}

+ (id)viewFromNibWithReuseIdentifier:(NSString*)reuseIdentifier
{
    NSAssert(!(reuseIdentifier == nil), @"reuseIdentifier is nil");
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
}

@end
