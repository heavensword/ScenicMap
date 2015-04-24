//
//  CustomScenicCalloutView.m
//  ScenicMapDemo
//
//  Created by Sword Zhou on 5/23/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CustomScenicCalloutView.h"
#import "ScenicAnnotation.h"

@interface CustomScenicCalloutView()

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CustomScenicCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.layer.borderWidth = 2.0;
    self.layer.cornerRadius = 4.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    [super awakeFromNib];
}

- (void)layoutSubviews
{
    self.nameLabel.text = self.scenic.name;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_nameLabel release];
    [super dealloc];
}
@end
