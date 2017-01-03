//
//  WASignupBottomButtonTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 1/2/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WASignupBottomButtonTableViewCell.h"

@implementation WASignupBottomButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buttonView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
