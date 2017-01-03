//
//  WASignupTableViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/2/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WASignupTableViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIImage *profileImage;

@property NSString *firstName;
@property NSString *lastName;
@property NSString *emailAddress;
@property NSString *academicLevel;
@property NSString *major;
@property NSInteger graduationYear;

@property NSString *password1;
@property NSString *password2;

@end
