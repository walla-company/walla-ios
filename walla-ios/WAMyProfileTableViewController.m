//
//  WAMyProfileTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileTableViewController.h"

@interface WAMyProfileTableViewController ()

@end

@implementation WAMyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileMainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAMyProfileTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 65.0;
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    // Initialize values
    self.titleArray = @[@"Edit profile", @"My friends", @"My groups", @"My interests", @"About Walla", @"Logout"];
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
    
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WAMyProfileMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.nameLabel.text = @"Name";
        cell.infoLabel.text = @"Grade\nMajor";
        cell.locationLabel.text = @"From city, country";
        
        return cell;
    }
    
    WAMyProfileTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.customTextLabel.text = self.titleArray[indexPath.row - 1];
    
    if (indexPath.row == 6) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
        cell.textLabel.textColor = [[UIColor alloc] initWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 1:
            [self performSegueWithIdentifier:@"openEditProfile" sender:self];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"openMyFriends" sender:self];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"openMyGroups" sender:self];
            break;
            
        case 4:
            [self performSegueWithIdentifier:@"openMyInterests" sender:self];
            break;
            
        case 5:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.wallasquad.com/"] options:@{} completionHandler:nil];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
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
