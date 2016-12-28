//
//  WAMyProfileGroupsTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileGroupsTableViewController.h"

#import "WAGroup.h"

@interface WAMyProfileGroupsTableViewController ()

@end

@implementation WAMyProfileGroupsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Groups";
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAGroupShadowTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [WAValues defaultTableViewBackgroundColor];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    // Initialize values
    
    WAGroup *group1 = [[WAGroup alloc] initWithName:@"Something Borrowed Something Blue" shortName:@"SBSB" groupID:@"1" color:[UIColor orangeColor]];
    WAGroup *group2 = [[WAGroup alloc] initWithName:@"Mechanical Engineers" shortName:@"MechEng" groupID:@"2" color:[UIColor purpleColor]];
    WAGroup *group3 = [[WAGroup alloc] initWithName:@"Residential Assisstants" shortName:@"RA" groupID:@"3" color:[UIColor greenColor]];
    WAGroup *group4 = [[WAGroup alloc] initWithName:@"Group 1" shortName:@"G1" groupID:@"4" color:[UIColor magentaColor]];
    WAGroup *group5 = [[WAGroup alloc] initWithName:@"Group 2" shortName:@"G2" groupID:@"3" color:[UIColor blueColor]];
    
    self.groups = @[group1, group2, group3, group4, group5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WAGroupShadowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    WAGroup *group = [self.groups objectAtIndex:indexPath.row];
    
    cell.groupNameLabel.text = group.name;
    cell.groupTagViewLabel.text = group.shortName;
    
    cell.groupTagView.backgroundColor = group.groupColor;
    
    cell.groupTagView.layer.cornerRadius = 8.0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"openViewGroup" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
