//
//  WAViewActivityViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewActivityViewController.h"

@interface WAViewActivityViewController ()

@end

@implementation WAViewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up view activity table view
    
    self.viewActivityTableView.delegate = self;
    self.viewActivityTableView.dataSource = self;
    
    self.viewActivityTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityAttendeesTableViewCell" bundle:nil] forCellReuseIdentifier:@"attendeesCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityButtonsTableViewCell" bundle:nil] forCellReuseIdentifier:@"buttonsCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityHostTableViewCell" bundle:nil] forCellReuseIdentifier:@"hostCell"];
    [self.viewActivityTableView registerNib:[UINib nibWithNibName:@"WAViewActivityDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"detailsCell"];
    
    self.viewActivityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.viewActivityTableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.viewActivityTableView.showsVerticalScrollIndicator = false;
    
    self.viewActivityTableView.rowHeight = UITableViewAutomaticDimension;
    self.viewActivityTableView.estimatedRowHeight = 150.0;
    
    // Set up colors
    
    self.tabColorLightGray = [[UIColor alloc] initWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:1.0];
    self.tabColorOffwhite = [[UIColor alloc] initWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
    self.tabColorOrange = [[UIColor alloc] initWithRed:244.0/255.0 green:201.0/255.0 blue:146.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WAViewActivityInfoTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell.activityHeaderView setTabs:@[@[@"Interest", [UIColor whiteColor], self.tabColorLightGray, @false], @[@"Interest", self.tabColorOffwhite, self.tabColorLightGray, @false], @[@"Group", self.tabColorOrange, [UIColor whiteColor], @true]]];
        
        cell.activityHeaderView.delegate = self;
        
        cell.activityHeaderView.groupID = @"GROUPID";
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        WAViewActivityLocationTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        WAViewActivityAttendeesTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"attendeesCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    if (indexPath.row == 3) {
        
        WAViewActivityButtonsTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"buttonsCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.goingView.backgroundColor = [[UIColor alloc] initWithRed:99.0/255.0 green:201.0/255.0 blue:249.0/255.0 alpha:1.0];
        cell.interestedView.backgroundColor = [[UIColor alloc] initWithRed:99.0/255.0 green:201.0/255.0 blue:249.0/255.0 alpha:1.0];
        cell.inviteView.backgroundColor = [[UIColor alloc] initWithRed:99.0/255.0 green:201.0/255.0 blue:249.0/255.0 alpha:1.0];
        cell.shareView.backgroundColor = [[UIColor alloc] initWithRed:99.0/255.0 green:201.0/255.0 blue:249.0/255.0 alpha:1.0];
        
        cell.goingView.layer.cornerRadius = 8.0;
        cell.interestedView.layer.cornerRadius = 8.0;
        cell.inviteView.layer.cornerRadius = 8.0;
        cell.shareView.layer.cornerRadius = 8.0;
        
        return cell;
    }
    
    if (indexPath.row == 4) {
        
        WAViewActivityHostTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"hostCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    WAViewActivityDetailsTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

#pragma mark - Tab header view delegate

- (void)activityTabButtonPressed:(NSString *)groupID {
    
    NSLog(@"Tab pressed: %@", groupID);
    
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
