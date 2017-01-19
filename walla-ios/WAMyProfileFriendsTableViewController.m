//
//  WAMyProfileFriendsTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileFriendsTableViewController.h"

#import "WAViewUserTableViewController.h"

#import "WAServer.h"
#import "WAValues.h"

@import Firebase;

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
    
    // Initialize defualt values
    
    self.profileImages = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserFriendsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *users){
        
        self.userFriendIDs = users;
        
        [self loadUserFriends];
    }];
}

- (void)loadUserFriends {
    
    self.userFriendsArray =[[NSMutableArray alloc] init];
    
    for (NSString *userID in self.userFriendIDs) {
        
        [WAServer getUserBasicInfoWithID:userID completion:^(NSDictionary *user){
            
            [self loadProfileImage:[user objectForKey:@"profile_image_url"] uid:[user objectForKey:@"user_id"]];
            
            [self.userFriendsArray addObject:user];
            
            [self.userFriendsArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true]]];
            
            [self.tableView reloadData];
        }];
    }
    
    if ([self.userFriendIDs count] == 0) [self.tableView reloadData];
}

- (void)loadProfileImage:(NSString *)profileImageURL uid:(NSString *)uid {
    
    NSLog(@"loadProfileImage: %@ : %@", profileImageURL, uid);
    
    if ([profileImageURL isEqualToString:@""]) {
        
        [self.profileImages setObject:[UIImage imageNamed:@"BlankCircle"] forKey:uid];
        
        [self.tableView reloadData];
        
    }
    else if (![self.profileImages objectForKey:uid]) {
        
        [self.profileImages setObject:[UIImage imageNamed:@"BlankCircle"] forKey:uid];
        
        [self.tableView reloadData];
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:profileImageURL];
        
        [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Error downloading profile image: %@", error);
                
            } else {
                
                [self.profileImages setObject:[UIImage imageWithData:data] forKey:uid];
                [self.tableView reloadData];
            }
        }];
    }
    
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
    
    return [self.userFriendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WAUserShadowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *user = [self.userFriendsArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [user objectForKey:@"name"];
    
    cell.infoLabel.text = [NSString stringWithFormat:@"Class of %@ / %@", [user objectForKey:@"graduation_year"], [user objectForKey:@"major"]];
    
    cell.profileImageView.image = [self.profileImages objectForKey:[user objectForKey:@"user_id"]];
    
    cell.profileImageView.layer.cornerRadius = 17.5;
    cell.profileImageView.clipsToBounds = true;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.openUserID = [[self.userFriendsArray objectAtIndex:indexPath.row] objectForKey:@"user_id"];
    
    [self performSegueWithIdentifier:@"openViewUser" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openViewUser"]) {
        
        WAViewUserTableViewController *destinationController = (WAViewUserTableViewController *) [segue destinationViewController];
        destinationController.viewingUserID = self.openUserID;
    }
    
}

@end
