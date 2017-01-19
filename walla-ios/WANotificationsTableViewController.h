//
//  WANotificationsTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WANotificationsTableViewController : UITableViewController

@property NSMutableArray *notificationsArray;

@property NSMutableDictionary *profileImagesDictionary;

@property NSString *openActivityID;

@end
