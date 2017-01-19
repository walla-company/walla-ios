//
//  WACalendarTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/18/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAActivityTableViewCell.h"

@interface WACalendarTableViewController : UITableViewController <WAActivityTabDelegate>

@property NSString *openGroupID;
@property NSString *openActivityID;

@property NSMutableDictionary *activitiesDictionary;
@property NSArray *activitiesArray;
@property NSArray *calendarItemsArrays;

@property NSMutableDictionary *userInfoDictionary;

@end
