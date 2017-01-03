//
//  WALoginSignupButtonTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/2/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAShadowView.h"

@interface WALoginSignupButtonTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *buttonView;

@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) IBOutlet WAShadowView *shadowView;

@end
