//
//  WAViewUserTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewUserTableViewController.h"

#import "WAViewActivityViewController.h"
#import "WAViewGroupTableViewController.h"

@interface WAViewUserTableViewController ()

@end

@implementation WAViewUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"USERID: %@", self.viewingUserID);
    
    self.title = @"Profile";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewUserProfileTableViewCell" bundle:nil] forCellReuseIdentifier:@"profileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewUserDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 170.0;
    
    // Set up colors
    
    self.tabColorLightGray = [[UIColor alloc] initWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
    self.tabColorOffwhite = [[UIColor alloc] initWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
    self.tabColorOrange = [[UIColor alloc] initWithRed:244.0/255.0 green:201.0/255.0 blue:146.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) return 2;
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            WAViewUserProfileTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            cell.delegate = self;
            
            return cell;
        }
        
        WAViewUserDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    WAActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.headerView setTabs:@[@[@"Interest", [UIColor whiteColor], self.tabColorLightGray, @false], @[@"Interest", self.tabColorOffwhite, self.tabColorLightGray, @false], @[@"Group", self.tabColorOrange, [UIColor whiteColor], @true]]];
    
    cell.headerView.delegate = self;
    
    cell.headerView.groupID = @"GROUPID";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return [[UIView alloc] init];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    
    headerView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, self.tableView.frame.size.width-30, 20)];
    
    label.textColor = [UIColor colorWithRed:143./255.0 green:142./255.0 blue:148./255.0 alpha:1.0];
    
    label.text = @"Events Hosted";
    
    label.font = [UIFont systemFontOfSize:14.0];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0;
    }
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        WAViewActivityViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewActivityViewController"];
        destinationController.viewingActivityID = @"ACTIVITYID";
        [self.navigationController pushViewController:destinationController animated:YES];
    }
    
}

#pragma mark - Tab header view delegate

- (void)activityTabButtonPressed:(NSString *)groupID {
    
    NSLog(@"Tab pressed: %@", groupID);
    
    WAViewGroupTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewGroupTableViewController"];
    destinationController.viewingGroupID = groupID;
    [self.navigationController pushViewController:destinationController animated:YES];
}

#pragma mark - User profile cell delegate

- (void)showMoreLessButtonPressed {
    
    NSLog(@"showMoreLessButtonPressed");
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)userGroupSelected:(NSString *)groupID {
    
    NSLog(@"Group selected: %@", groupID);
    
    WAViewGroupTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewGroupTableViewController"];
    destinationController.viewingGroupID = groupID;
    [self.navigationController pushViewController:destinationController animated:YES];
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

@end
