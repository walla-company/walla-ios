//
//  WAMyProfileTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAMyProfileTableViewController : UITableViewController

@property NSArray *titleArray;

@property NSString *name;
@property NSString *academicLevel;
@property NSString *graduationYear;
@property NSString *major;
@property NSString *hometown;
@property NSString *profileImageURL;

@property UIImage *profileImage;

@end
