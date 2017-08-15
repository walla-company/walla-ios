//
//  WAMyProfileTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAUser.h"

@interface WAMyProfileTableViewController : UITableViewController

@property NSArray *titleArray;

@property WAUser *user;

@property UIImage *profileImage;

@property NSMutableDictionary *groupsDictionary;

@property NSString *userId;

@end
