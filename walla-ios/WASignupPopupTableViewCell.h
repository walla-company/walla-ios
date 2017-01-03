//
//  WASignupPopupTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/2/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAShadowView.h"

@interface WASignupPopupTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet WAShadowView *shadowView;

@property (strong, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) IBOutlet UIButton *button;

@end
