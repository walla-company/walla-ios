//
//  SettingsTableViewCell.h
//  walla-ios
//
//  Created by Stas Tomych on 8/30/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WASettingsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellSubtitleLabel;

@end
