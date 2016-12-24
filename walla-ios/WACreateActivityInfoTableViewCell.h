//
//  WACreateActivityInfoTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface WACreateActivityInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *activityTitleTextField;

@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startTimeButton;

@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *endTimeButton;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet MKMapView *locationMapView;

@property (strong, nonatomic) IBOutlet UITextField *detailsTextField;

@property (strong, nonatomic) IBOutlet UITextField *groupTextField;

@end
