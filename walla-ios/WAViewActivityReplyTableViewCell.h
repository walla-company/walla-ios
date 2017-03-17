//
//  WAViewActivityReplyTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/15/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAViewActivityReplyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *interestedButton;
@property (strong, nonatomic) IBOutlet UIButton *goingButton;

@property (strong, nonatomic) IBOutlet UILabel *interestedLabel;
@property (strong, nonatomic) IBOutlet UILabel *goingLabel;

@property (strong, nonatomic) IBOutlet UIView *interestedView;
@property (strong, nonatomic) IBOutlet UIView *goingView;

@end
