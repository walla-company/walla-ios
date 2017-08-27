//
//  WAProfileTextTableViewCell.h
//  walla-ios
//
//  Created by Stas Tomych on 8/21/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAProfileTextTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellContentLabel;

@end
