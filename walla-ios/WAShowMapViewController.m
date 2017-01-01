//
//  WAShowMapViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/1/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAShowMapViewController.h"

@interface WAShowMapViewController ()

@end

@implementation WAShowMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"self.locationName: %@", self.locationName);
    
    self.title = self.locationName;
    
    GMSMapView *mapView = [[GMSMapView alloc] init];
    
    mapView.myLocationEnabled = true;
    
    GMSMarker *marker = [GMSMarker markerWithPosition:self.location.coordinate];
    marker.title = self.locationName;
    marker.map = mapView;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.location.coordinate zoom:16];
    [mapView setCamera:camera];
    
    self.view = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
