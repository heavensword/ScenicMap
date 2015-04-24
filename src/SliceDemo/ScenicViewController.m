//
//  ViewController.m
//  SliceDemo
//
//  Created by Sword Zhou on 5/10/13.
//  Copyright (c) 2013 Sword Zhou. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "ScenicViewController.h"
#import "MapSlice.h"
#import "ScenicMapView.h"
#import "ScenicMap.h"
#import "Map.h"
#import "ScenicAnnotation.h"
#import "ScenicAnnotationView.h"
#import "CustomScenicCalloutView.h"

@interface ScenicViewController ()<ScenicMapViewDelegate>
{
    ScenicAnnotation    *_removeScenic;
    ScenicMapView       *_scenicMapView;
}
@property (retain, nonatomic) IBOutlet UIButton *addButton;
@property (retain, nonatomic) IBOutlet UIButton *removeButton;

@end

@implementation ScenicViewController

- (ScenicMap*)getScenicMap
{
    ScenicMap *scenicMap = [[ScenicMap alloc] init];
    
    NSArray *mapNames = @[@"blocks1", @"blocks2", @"blocks3", @"blocks4"];
    NSInteger level = 1;
    for (NSString *name in mapNames) {        
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
        NSArray *sliceDicInfoArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *mapSlices = [NSMutableArray array];
        for (NSDictionary *sliceDic in sliceDicInfoArray) {
            MapSlice *mapSlice = [[MapSlice alloc] init];
            
            mapSlice.x = [sliceDic[@"block_x"] floatValue];
            mapSlice.y = [sliceDic[@"block_y"] floatValue];
            mapSlice.width = [sliceDic[@"block_w"] floatValue];
            mapSlice.height = [sliceDic[@"block_h"] floatValue];
            mapSlice.row = [sliceDic[@"row"] floatValue];
            mapSlice.col = [sliceDic[@"col"] floatValue];
            mapSlice.level = [sliceDic[@"level"] integerValue];
            
            NSString *fileName = [NSString stringWithFormat:@"level%d_%d_%d", mapSlice.level, mapSlice.col, mapSlice.row];
            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
            mapSlice.imageLocalPath = path;
            [mapSlices addObject:mapSlice];
            [mapSlice release];
        }
        Map *map = [[Map alloc] init];        
        map.mapSlices = mapSlices;
        [scenicMap addMap:map level:level];
        [map release];
        level++;
    }
    return [scenicMap autorelease];
}

- (void)addScenic
{
//    _leftTopCoordinate = CLLocationCoordinate2DMake(39.123456, 116.98278);
//    _rightBottomCoordinate = CLLocationCoordinate2DMake(37.123456, 118.98278);
    CGFloat latitude1 = 39.123456;
    CGFloat latitude2 = 37.123456;
    CGFloat longitude1 = 116.98278;
    CGFloat longitude2 = 118.98278;
    NSMutableArray *scenics = [NSMutableArray array];
    ScenicAnnotation *scenic = nil;
    
    CGFloat latitude = (latitude1 + latitude2)/2;
    CGFloat longitude = (longitude1 + longitude2)/2;
    scenic = [[ScenicAnnotation alloc] init];
    scenic.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    scenic.name = @"Name1";
    _removeScenic = [scenic retain];    
    [scenics addObject:scenic];
    [scenic release];
        
    latitude = (latitude1 + latitude2)/2 + (latitude1 + latitude2)/(3*100);
    longitude = (longitude1 + longitude2)/2 + (longitude1 + longitude2)/(3*100);
    scenic = [[ScenicAnnotation alloc] init];
    scenic.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    scenic.name = @"Name2";    
    [scenics addObject:scenic];
    [scenic release];

    latitude = (latitude1 + latitude2)/2 + (latitude1 + latitude2)/(2.5*100);
    longitude = (longitude1 + longitude2)/2 + (longitude1 + longitude2)/(2.75*100);
    scenic = [[ScenicAnnotation alloc] init];
    scenic.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    scenic.name = @"Name2";
    [scenics addObject:scenic];
    [scenic release];
    
    latitude = (latitude1 + latitude2)/2 + (latitude1 + latitude2)/(2.45*100);
    longitude = (longitude1 + longitude2)/2 + (longitude1 + longitude2)/(2.55*100);
    scenic = [[ScenicAnnotation alloc] init];
    scenic.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    scenic.name = @"Name2";
    [scenics addObject:scenic];
    [scenic release];
    
    latitude = (latitude1 + latitude2)/2 + (latitude1 + latitude2)/(4*100);
    longitude = (longitude1 + longitude2)/2 + (longitude1 + longitude2)/(4*100);
    scenic = [[ScenicAnnotation alloc] init];
    scenic.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    scenic.name = @"Name3";        
    [scenics addObject:scenic];
    [scenic release];
    
    [_scenicMapView addScenics:scenics];
}

- (IBAction)onAddButtonTouched:(id)sender
{
    [_scenicMapView addScenic:_removeScenic];
}

- (IBAction)onRemoveButtonTouched:(id)sender
{
    [_scenicMapView removeScenic:_removeScenic];
}

- (void)setup
{
    CGSize mapSize = CGSizeMake(2167, 1913);
    ScenicMap *scenicMap = [self getScenicMap];
    scenicMap.mapSize = mapSize;
    scenicMap.levelRange = 4;
    _scenicMapView = [[ScenicMapView alloc] initWithFrame:self.view.bounds map:scenicMap];
    
    _scenicMapView.mapDelegate = self;
    [self.view addSubview:_scenicMapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setup];
    [self addScenic];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.addButton];
    [self.view bringSubviewToFront:self.removeButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_removeScenic release];
    _removeScenic = nil;
    [_scenicMapView release];
    _scenicMapView = nil;
    [_addButton release];
    [_removeButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setAddButton:nil];
    [self setRemoveButton:nil];
    [super viewDidUnload];
}

#pragma mark - ScenicMapViewDelegate
- (void) scenicMapViewDidZoomLevel:(ScenicMapView*)scenicMapView level:(MapLevel)level
{
    ITTDINFO(@"did zoom level %d", level);
}

- (ScenicAnnotationView *)scenicMapView:(ScenicMapView*)mapView viewForAnnotation:(ScenicAnnotation*)scenic
{
   static NSString *identifier = @"ScenicAnnotationView";
   ScenicAnnotationView *annotationView =  [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[[ScenicAnnotationView alloc] initWithScenic:scenic reuseIdentifier:identifier] autorelease];
        annotationView.image = [UIImage imageNamed:@"map_pin_yellow"];
    }
    return annotationView;
}

- (ScenicCalloutView *)scenicMapView:(ScenicMapView*)mapView calloutViewForAnnotation:(ScenicAnnotation*)scenic
{    
    static NSString *identifier = @"CustomScenicCalloutView";
    ScenicCalloutView *calloutView =  nil;
    if (scenic == _removeScenic) {
    }
    else {
        calloutView = [mapView dequeueReusableCalloutViewWithIdentifier:identifier];
        if (!calloutView) {
            calloutView = [CustomScenicCalloutView viewFromNibWithReuseIdentifier:identifier];
        }
        calloutView.scenic = scenic;
    }
    return calloutView;
}
@end
