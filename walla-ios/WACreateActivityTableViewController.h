//
//  WACreateActivityTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@import GoogleMaps;
@import GooglePlaces;

#import <MapKit/MapKit.h>

#import "WACreateActivityDetailsTableViewCell.h"
#import "WACreateActivityTimeTableViewCell.h"
#import "WACreateActivityMeetingPlaceTableViewCell.h"
#import "WACreateActivityLocationTableViewCell.h"
#import "WACreateActivityHostTableViewCell.h"
#import "WACreateActivityFoodTableViewCell.h"
#import "WACreateActivityPostTableViewCell.h"

#import "WADatePickerViewController.h"
#import "WAGroupPickerViewController.h"
#import "WAAddLocationViewController.h"

#import "WAGroup.h"
#import "WAUser.h"

@interface WACreateActivityTableViewController : UITableViewController <WADatePickerViewControllerDelegate, WAGroupPickerViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, WAAddLocationViewControllerDelegate>

@property BOOL userVerified;

@property NSMutableArray *mapViews;

@property CLLocation *userLocation;
@property BOOL firstUserLocationUpdate;

@property NSString *activityTitle;
@property NSDate *activityStartTime;
@property NSString *meetingPlace;
@property GMSPlace *activityLocation;
@property BOOL freeFood;

@property UIColor *notSelectedColor;
@property UIColor *selectedColor;
typedef NS_ENUM(NSUInteger, ShapeType) {
    kDetailsCellRow = 0,
    kTimeCellRow = 1,
    kMeetingPlaceCellRow = 2,
    kLocationCellRow = 3,
    kFoodCellRow = 4,
    kPostCellRow = 5,
};

@property NSArray *userGroupIDs;

@property NSString *titlePlaceHolder;

@end
