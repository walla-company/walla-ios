//
//  WACreateActivityLocationTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@import GoogleMaps;

@interface WACreateActivityLocationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet GMSMapView *locationMap;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UIButton *locationButton;

@end
