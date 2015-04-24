//
//  ScenicAnnotationView.m
//  SliceDemo
//
//  Created by Sword Zhou on 5/21/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import "ScenicAnnotationView.h"

@interface ScenicAnnotationView()
{
    UIImageView *_imageView;
    void (^_onHandleTapBlock)(ScenicAnnotationView*);
}

@end

@implementation ScenicAnnotationView

@synthesize image = _image;
@synthesize scenic = _scenic;
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize onHandleTapBlock = _onHandleTapBlock;

- (void)dealloc
{
    [_scenic release];
    _scenic = nil;
    [_onHandleTapBlock release];
    _onHandleTapBlock = nil;
    [_imageView release];
    _imageView = nil;
    [_reuseIdentifier release];
    _reuseIdentifier = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (id)initWithScenic:(ScenicAnnotation*)scenic reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super init];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
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
    if (self.image) {
        _imageView.image = self.image;
        CGSize size = self.image.size;
        CGFloat scale = 1.0;//1.0/[[UIScreen mainScreen] scale];
        CGRect rect = CGRectMake(0, 0, size.width * scale, size.height * scale);
        _imageView.frame = rect;
    }
    [self addSubview:_imageView];
}

- (void)setup
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 29)];
    _imageView.image = [UIImage imageNamed:@"map_pin_green"] ;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
}

- (void)handleTap:(UITapGestureRecognizer*)gestureRecognizer
{
    ITTDINFO(@"- (void)handleTap:(UITapGestureRecognizer*)gestureRecognizer");
    _onHandleTapBlock(self);
}
@end
