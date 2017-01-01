//
//  WADiscoverViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WADiscoverViewController.h"

#import "WAViewUserTableViewController.h"
#import "WAViewGroupTableViewController.h"

@interface WADiscoverViewController ()

@end

@implementation WADiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up table view
    
    self.discoverTableView.delegate = self;
    self.discoverTableView.dataSource = self;
    
    self.discoverTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.discoverTableView registerNib:[UINib nibWithNibName:@"WADiscoverFriendSuggestionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendSuggestionsCell"];
    [self.discoverTableView registerNib:[UINib nibWithNibName:@"WADiscoverSuggestedGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"suggestedGroupCell"];
    
    self.discoverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.discoverTableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.discoverTableView.showsVerticalScrollIndicator = false;
    
    self.discoverTableView.rowHeight = UITableViewAutomaticDimension;
    self.discoverTableView.estimatedRowHeight = 100.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!(tableView == self.discoverTableView)) return 0;
    
    if (section == 0) return 1;
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        WADiscoverFriendSuggestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendSuggestionsCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        return cell;
    }
    
    WADiscoverSuggestedGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"suggestedGroupCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.groupTagView.layer.cornerRadius = 8.0;
    cell.groupTagView.clipsToBounds = false;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.discoverTableView.frame.size.width, 30)];
    
    headerView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, self.discoverTableView.frame.size.width-30, 30)];
    
    label.textColor = [UIColor colorWithRed:143./255.0 green:142./255.0 blue:148./255.0 alpha:1.0];
    
    label.text = (section == 0) ? @"Suggested friends" : @"Suggested groups";
    
    label.font = [UIFont systemFontOfSize:14.0];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        self.openGroupID = @"GROUPID";
        
        [self performSegueWithIdentifier:@"openViewGroup" sender:self];
    }
    
}

#pragma mark - Suggested users cell delegate

- (void)suggestedUserSelected:(NSString *)userID {
    
    NSLog(@"SELECTED: %@", userID);
    
    self.openUserID = @"USERID";
    
    [self performSegueWithIdentifier:@"openViewUser" sender:self];
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openViewUser"]) {
        
        WAViewUserTableViewController *destinationController = (WAViewUserTableViewController *) [segue destinationViewController];
        destinationController.viewingUserID = self.openUserID;
    }
    else if ([segue.identifier isEqualToString:@"openViewGroup"]) {
        WAViewGroupTableViewController *destinationController = (WAViewGroupTableViewController *) [segue destinationViewController];
        destinationController.viewingGroupID = self.openGroupID;
    }
}

@end
