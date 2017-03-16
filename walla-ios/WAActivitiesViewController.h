//
//  WAActivitiesViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAActivityTableViewCell.h"

#import "WAFilterCollectionViewCell.h"

@import Firebase;

@interface WAActivitiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property BOOL showAllActivities;

@property (strong, nonatomic) IBOutlet UIButton *allButton;
@property (strong, nonatomic) IBOutlet UIButton *todayButton;

@property (strong, nonatomic) IBOutlet UIView *allHighlightView;
@property (strong, nonatomic) IBOutlet UIView *todayHighlightView;


@property (strong, nonatomic) IBOutlet UITableView *activitiesTableView;

@property NSString *openGroupID;
@property NSString *openActivityID;

@property NSArray *activitiesArray;
@property NSMutableArray *filteredActivities;

@property NSMutableDictionary *userNamesDictionary;
@property NSMutableDictionary *profileImagesDictionary;

- (IBAction)allButtonPressed:(id)sender;
- (IBAction)todayButtonPressed:(id)sender;

@end
