//
//  WAViewUserProfileTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewUserProfileTableViewCell.h"

@implementation WAViewUserProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addFriendView.layer.cornerRadius = 8.0;
    
    // Set up table view
    
    self.groupsTableView.delegate = self;
    self.groupsTableView.dataSource = self;
    
    self.groupsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.groupsTableView registerNib:[UINib nibWithNibName:@"WAViewUserGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    [self.groupsTableView registerNib:[UINib nibWithNibName:@"WAViewUserGroupMoreLessTableViewCell" bundle:nil] forCellReuseIdentifier:@"moreLessCell"];
    
    self.groupsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.groupsTableView.showsVerticalScrollIndicator = false;
    
    self.groupsTableView.rowHeight = UITableViewAutomaticDimension;
    self.groupsTableView.estimatedRowHeight = 20.0;
    
    self.groupsTableView.scrollEnabled = false;
    
    // Set up default values;
    
    WAGroup *group1 = [[WAGroup alloc] initWithName:@"Something Borrowed Something Blue" shortName:@"SBSB" groupID:@"1" color:[UIColor orangeColor]];
    WAGroup *group2 = [[WAGroup alloc] initWithName:@"Mechanical Engineers" shortName:@"MechEng" groupID:@"2" color:[UIColor purpleColor]];
    WAGroup *group3 = [[WAGroup alloc] initWithName:@"Residential Assisstants" shortName:@"RA" groupID:@"3" color:[UIColor greenColor]];
    WAGroup *group4 = [[WAGroup alloc] initWithName:@"Group 1" shortName:@"G1" groupID:@"4" color:[UIColor magentaColor]];
    WAGroup *group5 = [[WAGroup alloc] initWithName:@"Group 2" shortName:@"G2" groupID:@"3" color:[UIColor blueColor]];
    
    self.grouspArray = @[group1, group2, group3, group4, group5];
    
    self.showMore = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.showMore) {
        
        self.groupsTableViewHeight.constant = ([self.grouspArray count] * 24) + 15;
        
        return [self.grouspArray count] + 1;
    }
    
    self.groupsTableViewHeight.constant = ([self.grouspArray count] > 3) ? (3 * 24) + 15 : [self.grouspArray count] * 24;
    
    return ([self.grouspArray count] > 3) ? 4 : [self.grouspArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((self.showMore && ([self.grouspArray count] > 3 && indexPath.row == [self.grouspArray count])) || (!self.showMore && ([self.grouspArray count] > 3 && indexPath.row == 3))) {
        
        WAViewUserGroupMoreLessTableViewCell *cell = [self.groupsTableView dequeueReusableCellWithIdentifier:@"moreLessCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.showMoreLessButton addTarget:self action:@selector(showMoreLessButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.showMoreLessButton setTitle:(self.showMore) ? @"Show less" : @"Show more" forState:UIControlStateNormal];
        
        return cell;
    }
    
    WAViewUserGroupTableViewCell *cell = [self.groupsTableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WAGroup *group = [self.grouspArray objectAtIndex:indexPath.row];
    
    cell.groupNameLabel.text = group.name;
    cell.groupTagViewLabel.text = group.shortName;
    cell.groupTagView.backgroundColor = group.groupColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!(self.showMore && ([self.grouspArray count] > 3 && indexPath.row == [self.grouspArray count])) && !(!self.showMore && ([self.grouspArray count] > 3 && indexPath.row == 3))) {
        
        [self.delegate userGroupSelected:@"GROUPID"];
    }
    
}

# pragma mark - Button targets

- (void)showMoreLessButtonPressed:(UIButton *)button {
    
    self.showMore = !self.showMore;
    
    [self.groupsTableView reloadData];
    
    [self.delegate showMoreLessButtonPressed];
}

@end
