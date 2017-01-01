//
//  WAViewActivityViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/26/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAViewActivityViewController.h"

#import "WAViewGroupTableViewController.h"

#import "WAViewUserTableViewController.h"

#import "WAShowMapViewController.h"

#import "WAServer.h"

#import "WAValues.h"

@interface WAViewActivityViewController ()

@end

@implementation WAViewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ACTIVITYID: %@", self.viewingActivityID);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
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
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
        [WAServer getActivityWithID:self.viewingActivityID completion:^(WAActivity *activity){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                self.viewingActivity = activity;
                if (self.viewingActivity.activityPublic) self.title = @"Public";
                else self.title = @"Private";
                [self.viewActivityTableView reloadData];
            });
        }];
    });
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
    
    if (self.viewingActivity) return 6;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        WAViewActivityInfoTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        NSMutableArray *headerTabs = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[self.viewingActivity.interests count]; i++) {
            NSString *interest = [self.viewingActivity.interests objectAtIndex:i];
            
            switch (i) {
                case 0:
                    [headerTabs addObject:@[interest, [UIColor whiteColor], [WAValues tabTextColorLightGray], @false]];
                    break;
                case 1:
                    [headerTabs addObject:@[interest, [WAValues tabColorOffWhite], [WAValues tabTextColorLightGray], @false]];
                    break;
                    
                default:
                    break;
            }
        }
        
        if ([self.viewingActivity.hostGroupID length] > 0) {
            [headerTabs addObject:@[self.viewingActivity.hostGroupShortName, [WAValues tabColorOrange], [UIColor whiteColor], @true]];
            cell.activityHeaderView.groupID = self.viewingActivity.hostGroupID;
        }
        
        [cell.activityHeaderView setTabs:headerTabs];
        
        cell.activityHeaderView.delegate = self;
        
        cell.titleLabel.text = self.viewingActivity.title;
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"HH:mm aa"];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"HH:mm"];
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setDateFormat:@"MM/dd"];
        
        NSString *startTimeString = [formatter1 stringFromDate:self.viewingActivity.startTime];
        NSString *endTimeString = [formatter2 stringFromDate:self.viewingActivity.endTime];
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%@\nto %@", startTimeString, endTimeString];
        
        cell.dateLabel.text = [formatter3 stringFromDate:self.viewingActivity.startTime];
        
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        WAViewActivityLocationTableViewCell *cell = [self.viewActivityTableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.locationLabel.text = self.viewingActivity.locationName;
        
        [cell.showMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    cell.detailsTextLabel.text = self.viewingActivity.details;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        WAViewUserTableViewController *destinationController = [self.storyboard instantiateViewControllerWithIdentifier:@"WAViewUserTableViewController"];
        destinationController.viewingUserID = @"USERID";
        [self.navigationController pushViewController:destinationController animated:YES];
    }
    
}

# pragma mark - Button targets

- (void)showMapButtonPressed:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"openShowMap" sender:self];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openShowMap"]) {
        
        WAShowMapViewController *destinationController = (WAShowMapViewController *) [segue destinationViewController];
        destinationController.location = self.viewingActivity.location;
        destinationController.locationName = self.viewingActivity.locationName;
        destinationController.locationAddress = self.viewingActivity.locationAddress;
    }
}

@end
