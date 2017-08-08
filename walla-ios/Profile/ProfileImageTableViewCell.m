//
//  ProfileImageTableViewCell.m
//  walla-ios
//
//  Created by Stas Tomych on 8/8/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "ProfileImageTableViewCell.h"
#import "WAValues.h"

@interface ProfileImageTableViewCell()

@property (nonatomic, weak) IBOutlet UIImageView *profileImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *userInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *browniesLabel;
@property (nonatomic, weak) IBOutlet UIButton *editButton;

@end

@implementation ProfileImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.height / 2;
    self.profileImageView.layer.borderWidth = 5.0f;
    self.profileImageView.layer.borderColor = [WAValues wallaOrangeColor].CGColor;
    self.editButton.layer.cornerRadius = self.editButton.bounds.size.height / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
