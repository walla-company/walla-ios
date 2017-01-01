//
//  WAViewGroupTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewGroupTableViewController.h"

#import "WAViewActivityViewController.h"

#import "WAValues.h"

@interface WAViewGroupTableViewController ()

@end

@implementation WAViewGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"GROUPID: %@", self.viewingGroupID);
    
    self.title = @"Group";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewGroupInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewGroupDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            WAViewGroupInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            cell.groupTagView.layer.cornerRadius = 8.0;
            cell.groupTagView.clipsToBounds = false;
            
            cell.joinView.layer.cornerRadius = 8.0;
            
            return cell;
        }
        
        WAViewGroupDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    WAActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.headerView setTabs:@[@[@"Interest", [UIColor whiteColor], [WAValues tabTextColorLightGray], @false], @[@"Interest", [WAValues tabColorOffWhite], [WAValues tabTextColorLightGray], @false], @[@"Group", [WAValues tabColorOrange], [UIColor whiteColor], @true]]];
    
    cell.headerView.delegate = self;
    
    cell.headerView.groupID = @"GROUPID";
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

@end
