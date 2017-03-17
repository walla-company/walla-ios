//
//  WANotificationsTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/17/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WANotificationsTableViewController.h"

#import "WANotificationsFriendRequestTableViewCell.h"
#import "WANotificationsTextTableViewCell.h"

#import "WAViewActivityTableViewController.h"

#import "WAServer.h"
#import "WAValues.h"

@import Firebase;

static NSString *NOTIFICATION_FRIEND_REQUEST = @"friend_request";
static NSString *NOTIFICATION_USER_INVITED = @"user_invited";
static NSString *NOTIFICATION_GROUP_INVITED = @"group_invited";
static NSString *NOTIFICATION_DISCUSSION_POSTED = @"discussion_posted";

@interface WANotificationsTableViewController ()

@end

@implementation WANotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up activities table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WANotificationsFriendRequestTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendRequestCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WANotificationsTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120.0;
    
    // Initialize default values
    
    self.notificationsArray = [[NSMutableArray alloc] init];
    self.profileImagesDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getNotifications:^(NSArray *notifications) {
        
        NSLog(@"notifications: %@", notifications);
        
        NSMutableArray *friendRequestsArray = [[NSMutableArray alloc] init];
        NSMutableArray *othersArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *notification in notifications) {
            
            if ([notification[@"type"] isEqualToString:NOTIFICATION_FRIEND_REQUEST]) {
                [friendRequestsArray addObject:notification];
            }
            else {
                [othersArray addObject:notification];
            }
            
            if ([notification[@"read"] boolValue]) {
                [WAServer updateNotificationRead:notification[@"notification_id"] completion:nil];
            }
            
        }
        
        [friendRequestsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"time_created" ascending:false]]];
        [othersArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"time_created" ascending:false]]];
        
        [self.notificationsArray removeAllObjects];
        
        [self.notificationsArray addObjectsFromArray:friendRequestsArray];
        [self.notificationsArray addObjectsFromArray:othersArray];
        
        [self.tableView reloadData];
        
    }];
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
    
    return [self.notificationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *notification = [self.notificationsArray objectAtIndex:indexPath.row];
    
    if ([notification[@"type"] isEqualToString:NOTIFICATION_FRIEND_REQUEST]) {
        
        WANotificationsFriendRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendRequestCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        [cell.acceptButton addTarget:self action:@selector(acceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.ignoreButton addTarget:self action:@selector(ignoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.acceptButton.tag = indexPath.row;
        cell.ignoreButton.tag = indexPath.row;
        
        cell.acceptView.layer.cornerRadius = 6.0;
        cell.ignoreView.layer.cornerRadius = 6.0;
        
        cell.infoLabel.text = notification[@"text"];
        
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 20.0;
        
        UIImage *proifleImage = [self.profileImagesDictionary objectForKey:notification[@"sender"]];
        
        if (proifleImage) {
            cell.profileImageView.image = proifleImage;
        }
        else {
            cell.profileImageView.image = [UIImage imageNamed:@"BlankCircle"];
            [self loadProfileImage:notification[@"profile_image_url"] forUserID:notification[@"sender"]];
        }
        
        return cell;
        
    }
    
    WANotificationsTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.infoLabel.text = notification[@"text"];
    
    UIImage *proifleImage = [self.profileImagesDictionary objectForKey:notification[@"sender"]];
    
    if (proifleImage) {
        cell.profileImageView.image = proifleImage;
    }
    else {
        cell.profileImageView.image = [UIImage imageNamed:@"BlankCircle"];
        [self loadProfileImage:notification[@"profile_image_url"] forUserID:notification[@"sender"]];
    }
    
    cell.profileImageView.clipsToBounds = true;
    cell.profileImageView.layer.cornerRadius = 20.0;
    
    return cell;
}

- (void)loadProfileImage:(NSString *)profileImageURL forUserID:(NSString *)userID {
    
    if (![profileImageURL isEqualToString:@""]) {
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:profileImageURL];
        
        [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Error downloading profile image: %@", error);
                
            } else {
                
                [self.profileImagesDictionary setObject:[UIImage imageWithData:data] forKey:userID];
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *notification = [self.notificationsArray objectAtIndex:indexPath.row];
    
    if (![notification[@"type"] isEqualToString:NOTIFICATION_FRIEND_REQUEST]) {
        
        self.openActivityID = notification[@"activity_id"];
        
        [self performSegueWithIdentifier:@"openActivityDetails" sender:self];
    }
    
}

#pragma mark - Button targets

- (void)acceptButtonPressed:(UIButton *)button {
    
    NSString *uid = [[self.notificationsArray objectAtIndex:button.tag] objectForKey:@"sender"];
    
    [WAServer acceptFriendRequestWithUID:uid completion:nil];
    
    [self.notificationsArray removeObjectAtIndex:button.tag];
    
    [self.tableView reloadData];
    
}

- (void)ignoreButtonPressed:(UIButton *)button {
    
    NSString *uid = [[self.notificationsArray objectAtIndex:button.tag] objectForKey:@"sender"];
    
    [WAServer ignoreFriendRequestWithUID:uid completion:nil];
    
    [self.notificationsArray removeObjectAtIndex:button.tag];
    
    [self.tableView reloadData];
    
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
