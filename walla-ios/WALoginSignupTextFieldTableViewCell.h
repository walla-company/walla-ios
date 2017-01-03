//
//  WALoginSignupTextFieldTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/1/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAShadowView.h"

@interface WALoginSignupTextFieldTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet WAShadowView *shadowView;

@property (strong, nonatomic) IBOutlet UITextField *textField;

@end
