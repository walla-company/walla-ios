//
//  WAMyProfileGroupsTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileGroupsTableViewController.h"

#import "WAViewGroupTableViewController.h"

#import "WAServer.h"
#import "WAValues.h"

@import Firebase;

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
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserGroupsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *groups){
       
        self.userGroupIDs = groups;
        
        [self loadUserGroups];
    }];
}

- (void)loadUserGroups {
    
    self.userGroupsArray =[[NSMutableArray alloc] init];
    
    for (NSString *groupID in self.userGroupIDs) {
        
        [WAServer getGroupBasicInfoWithID:groupID completion:^(NSDictionary *group){
            
            [self.userGroupsArray addObject:group];
            
            [self.userGroupsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]]];
            
            [self.tableView reloadData];
        }];
    }
    
    if ([self.userGroupIDs count] == 0) [self.tableView reloadData];
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
    
    return [self.userGroupsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WAGroupShadowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *group = [self.userGroupsArray objectAtIndex:indexPath.row];
    
    cell.groupNameLabel.text = group[@"name"];
    cell.groupTagViewLabel.text = group[@"short_name"];
    
    cell.groupTagView.backgroundColor = [WAValues colorFromHexString:group[@"color"]];
    
    cell.groupTagView.layer.cornerRadius = 8.0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.openGroupID = [[self.userGroupsArray objectAtIndex:indexPath.row] objectForKey:@"group_id"];
    
    [self performSegueWithIdentifier:@"openViewGroup" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openViewGroup"]) {
        
        WAViewGroupTableViewController *destinationController = (WAViewGroupTableViewController *) [segue destinationViewController];
        destinationController.viewingGroupID = self.openGroupID;
    }
    
}

@end
