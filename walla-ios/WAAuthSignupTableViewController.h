//
//  WAAuthSignupTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAAuthSignupTableViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property NSString *emailAddress;

@property UIImage *profileImage;

@property NSString *firstName;
@property NSString *lastName;

@property NSString *password;

@end
