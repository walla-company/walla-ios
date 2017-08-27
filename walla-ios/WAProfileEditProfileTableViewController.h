//
//  WAProfileEditProfileTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAUser.h"

@interface WAProfileEditProfileTableViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate>

@property WAUser *user;

//@property UIImage *profileImage;
//@property BOOL loadProfilePhoto;

@property NSMutableDictionary *groupsDictionary;

@end
