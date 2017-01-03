//
//  WALoginTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/1/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WALoginTableViewController : UITableViewController <UITextFieldDelegate>

@property NSString *emailAddress;

@property NSString *password;

@end
