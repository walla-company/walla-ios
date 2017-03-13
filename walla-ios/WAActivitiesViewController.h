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

@interface WAActivitiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WAActivityTabDelegate>

@property (strong, nonatomic) IBOutlet UITableView *activitiesTableView;

@property NSString *openGroupID;
@property NSString *openActivityID;

@property NSArray *activitiesArray;

@property NSMutableDictionary *userInfoDictionary;

@end
