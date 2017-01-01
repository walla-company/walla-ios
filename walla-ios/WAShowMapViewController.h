//
//  WAShowMapViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/1/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleMaps;

@interface WAShowMapViewController : UIViewController

@property CLLocation *location;

@property NSString *locationAddress;
@property NSString *locationName;

@end
