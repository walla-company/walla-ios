//
//  WACreateActivityFoodTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/12/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WACreateActivityFoodTableViewCell.h"

@interface WACreateActivityFoodTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *pizzaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pizzaIcon;

@end

@implementation WACreateActivityFoodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self foodSwitchChanged:self.foodSwitch];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)foodSwitchChanged:(UISwitch *)foodSwitch {
    BOOL hasFood = self.foodSwitch.isOn;
    self.pizzaLabel.hidden = !hasFood;
    self.pizzaIcon.hidden = !hasFood;
}


@end
