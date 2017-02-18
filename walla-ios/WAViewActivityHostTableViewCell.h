//
//  WAViewActivityHostTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAViewActivityHostTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *hostProfileImageView;

@property (strong, nonatomic) IBOutlet UILabel *hostNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *hostInfoLabel;

@property (strong, nonatomic) IBOutlet UIButton *hostButton;

@end
