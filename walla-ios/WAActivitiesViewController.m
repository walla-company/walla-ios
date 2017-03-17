//
//  WAActivitiesViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAActivitiesViewController.h"

#import "WAViewActivityTableViewController.h"

#import "WAValues.h"

#import "WAServer.h"

@interface WAActivitiesViewController ()

@end

@implementation WAActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up activities table view
    
    self.activitiesTableView.delegate = self;
    self.activitiesTableView.dataSource = self;
    
    self.activitiesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.activitiesTableView registerNib:[UINib nibWithNibName:@"WAActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"activityCell"];
    
    self.activitiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.activitiesTableView.backgroundColor = [WAValues defaultTableViewBackgroundColor];
    
    self.activitiesTableView.showsVerticalScrollIndicator = false;
    
    self.activitiesTableView.rowHeight = UITableViewAutomaticDimension;
    self.activitiesTableView.estimatedRowHeight = 170.0;
    
    self.activitiesTableView.contentInset = UIEdgeInsetsMake(self.activitiesTableView.contentInset.top + 40, 0, 0, 0);
    
    // Set up
    
    self.userNamesDictionary = [[NSMutableDictionary alloc] init];
    self.profileImagesDictionary = [[NSMutableDictionary alloc] init];
    
    self.filteredActivities = [[NSMutableArray alloc] init];
    
    self.showAllActivities = true;
    [self setupTopBar];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getActivitisFromLastHours:24.0 completion:^(NSArray *activities){
        
        NSLog(@"Activities loaded");
        
        self.activitiesArray = activities;
        [self.activitiesTableView reloadData];
        
        [self filterActivities];
    }];
}

- (void)filterActivities {
    
    [self.filteredActivities removeAllObjects];
    
    NSTimeInterval endOfDay = [[[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]] timeIntervalSince1970] + 86400;
    
    for (WAActivity *activity in self.activitiesArray) {
        
        if ([activity.startTime timeIntervalSince1970] < endOfDay) {
            [self.filteredActivities addObject:activity];
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTopBar {
    
    //[self.allButton setTitleColor:(self.showAllActivities) ? [WAValues barHighlightColor] : [UIColor clearColor]forState:UIControlStateNormal];
    //[self.todayButton setTitleColor:(self.showAllActivities) ? [UIColor clearColor] : [WAValues barHighlightColor] forState:UIControlStateNormal];
    
    self.allHighlightView.backgroundColor = (self.showAllActivities) ? [WAValues barHighlightColor] : [UIColor clearColor];
    self.todayHighlightView.backgroundColor = (self.showAllActivities) ? [UIColor clearColor] : [WAValues barHighlightColor];
}

- (IBAction)allButtonPressed:(id)sender {
    
    self.showAllActivities = true;
    [self setupTopBar];
    
    [self.activitiesTableView reloadData];
}

- (IBAction)todayButtonPressed:(id)sender {
    self.showAllActivities = false;
    [self setupTopBar];
    
    [self.activitiesTableView reloadData];
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.showAllActivities) return [self.activitiesArray count];
    
    return [self.filteredActivities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WAActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    WAActivity *activity;
    
    if (self.showAllActivities) activity = self.activitiesArray[indexPath.row];
    else activity = self.filteredActivities[indexPath.row];
    
    UIColor *cardColor = [UIColor whiteColor];
    
    if ([activity.goingUserIDs containsObject:[FIRAuth auth].currentUser.uid]) {
        
        cardColor = [WAValues colorFromHexString:@"#FFF4F4"];
    }
    else if ([activity.interestedUserIDs containsObject:[FIRAuth auth].currentUser.uid]) {
        
        cardColor = [WAValues colorFromHexString:@"#FEFFDF"];
    }
        
    cell.cardView.backgroundColor = cardColor;
    
    NSString *nameString = @"";
    
    if ([activity.hostGroupID isEqualToString:@""]) {
        
        if (self.userNamesDictionary[activity.host]) {
            nameString = self.userNamesDictionary[activity.host];
        }
        else {
            [self.userNamesDictionary setObject:@"" forKey:activity.host];
            [WAServer getUserBasicInfoWithID:activity.host completion:^ (NSDictionary *user) {
                NSLog(@"User Info: %@", user);
                
                [self.userNamesDictionary setObject:user[@"first_name"] forKey:activity.host];
                [self.activitiesTableView reloadData];
                
                [self loadProfileImageWithURL:user[@"profile_image_url"] forUID:activity.host];
            }];
        }
    }
    else {
        
        nameString = [NSString stringWithFormat:@"Hosted by %@", activity.hostGroupName];
    }
    
    UIImage *profileImage = [UIImage imageNamed:@"BlankCircle"];
    
    if (self.profileImagesDictionary[activity.host]) {
        profileImage = self.profileImagesDictionary[activity.host];
    }
    
    cell.nameLabel.text = nameString;
    
    cell.titleLabel.text = activity.title;
    
    cell.profileImageView.image = profileImage;
    
    cell.profileImageView.layer.cornerRadius = 17.5;
    cell.profileImageView.clipsToBounds = true;
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"h:mm aa"];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"M/d"];
    
    NSString *startTimeString = [formatter1 stringFromDate:activity.startTime];
    NSString *dateString = [formatter2 stringFromDate:activity.startTime];
    
    NSLog(@"%@ start time: %f", activity.activityID, [activity.startTime timeIntervalSince1970]);
    
    cell.timeLabel.text = startTimeString;
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ (%@)", [WAValues dayOfWeekFromDate:activity.startTime], dateString];
    
    if (activity.freeFood) cell.freeFoodImageView.hidden = false;
    else cell.freeFoodImageView.hidden = true;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"SELECTED");
    
    self.openActivityID = ((WAActivity *)self.activitiesArray[indexPath.row]).activityID;
    
    [self performSegueWithIdentifier:@"openActivityDetails" sender:self];
    
}

- (void)loadProfileImageWithURL:(NSString *)url forUID:(NSString *)userID {
    
    if (!self.profileImagesDictionary[userID]) {
        [self.profileImagesDictionary setObject:[UIImage imageNamed:@"BlankCircle"] forKey:userID];
        
        if (![url isEqualToString:@""]) {
            
            FIRStorage *storage = [FIRStorage storage];
            
            FIRStorageReference *imageRef = [storage referenceForURL:url];
            
            [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
                if (error != nil) {
                    
                    NSLog(@"Error downloading profile image: %@", error);
                    
                } else {
                    
                    [self.profileImagesDictionary setObject:[UIImage imageWithData:data] forKey:userID];
                    [self.activitiesTableView reloadData];
                }
            }];
        }
    }
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openActivityDetails"]) {
        
        WAViewActivityTableViewController *destinationController = (WAViewActivityTableViewController *) [segue destinationViewController];
        destinationController.viewingActivityID = self.openActivityID;
    }
}

@end
