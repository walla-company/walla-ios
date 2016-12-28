//
//  WAMyProfileFriendsTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileFriendsTableViewController.h"

#import "WAValues.h"
#import "WAUser.h"

@interface WAMyProfileFriendsTableViewController ()

@end

@implementation WAMyProfileFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Friends";
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAUserShadowTableViewCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [WAValues defaultTableViewBackgroundColor];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    // Initialize default values
    
    WAUser *user1 = [[WAUser alloc] initWithFirstName:@"Ben" lastName:@"Yang" userID:@"1" classYear:@"Freshman" major:@"Computer Science" image:nil];
    WAUser *user2 = [[WAUser alloc] initWithFirstName:@"Alexis" lastName:@"Angel" userID:@"2" classYear:@"Freshman" major:@"Economics" image:nil];
    WAUser *user3 = [[WAUser alloc] initWithFirstName:@"Mia" lastName:@"Carlson" userID:@"3" classYear:@"Freshman" major:@"Pre-med" image:nil];
    
    self.users = @[user1, user2, user3];
    
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
    
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WAUserShadowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WAUser *user = [self.users objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    cell.infoLabel.text = [NSString stringWithFormat:@"%@ / %@", user.classYear, user.major];
    
    cell.profileImageView.image = user.profileImage;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"openViewUser" sender:self];
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
