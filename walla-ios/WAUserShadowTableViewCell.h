//
//  WAUserShadowTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAUserShadowTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end
