//
//  WAViewActivityTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 2/4/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAViewActivityTableViewController.h"

#import "WAShowMapViewController.h"

#import "WAServer.h"

#import "WAValues.h"

@import Firebase;

@interface WAViewActivityTableViewController ()

@end

@implementation WAViewActivityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"ACTIVITYID: %@", self.viewingActivityID);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up view activity table view
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityReplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"replyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"textCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityMapTableViewCell" bundle:nil] forCellReuseIdentifier:@"mapCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityPostDiscussionTableViewCell" bundle:nil] forCellReuseIdentifier:@"postDiscussionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WAViewActivityExtraTableViewCell" bundle:nil] forCellReuseIdentifier:@"extraCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
    
    self.discussionPostText = @"";
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.userVerified = false;
    
    self.title = @"Activity";
    
    self.userNamesDictionary = [[NSMutableDictionary alloc] init];
    self.profileImagesDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getActivityWithID:self.viewingActivityID completion:^(WAActivity *activity){
        
        self.viewingActivity = activity;
        [self.tableView reloadData];
        
        NSLog(@"Activity host id: %@", self.viewingActivity.host);
        
        if (activity.activityDeleted) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Activity Deleted" message:@"This activity no longer exists." preferredStyle:UIAlertControllerStyleAlert];
            
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler: ^(UIAlertAction *action){
                
                [self.navigationController popViewControllerAnimated:true];
                
            }];
            
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:true completion:nil];
            
        }
    }];
    
    [self loadDiscussions];
    
    [WAServer getUserVerified:^(BOOL verified) {
        self.userVerified = verified;
        
        NSLog(@"self.userVerified: %@", (self.userVerified) ? @"true" : @"false");
    }];
}

- (void)loadDiscussions {
    
    [WAServer getDiscussions:self.viewingActivityID completion:^(NSArray *discussions) {
        self.discussions = discussions;
        
        self.discussions = [self.discussions sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            double first = [((NSDictionary *)a)[@"time_posted"] doubleValue];
            double second = [((NSDictionary *)b)[@"time_posted"] doubleValue];
            return first >= second;
        }];
        
        [self.tableView reloadData];
    }];
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
                    [self.tableView reloadData];
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.viewingActivity) {
        if (self.viewingActivity.activityDeleted) return 0;
        
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.viewingActivity.host isEqualToString:[FIRAuth auth].currentUser.uid]) return 6 + [self.discussions count];
    
    return 5 + [self.discussions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        WAViewActivityReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"replyCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.interestedView.backgroundColor = ([self.viewingActivity.interestedUserIDs containsObject:[FIRAuth auth].currentUser.uid]) ? [WAValues buttonInterestedColor] : [WAValues buttonBlueColor];
        cell.goingView.backgroundColor = ([self.viewingActivity.goingUserIDs containsObject:[FIRAuth auth].currentUser.uid]) ? [WAValues buttonGoingColor] : [WAValues buttonBlueColor];
        
        [cell.interestedButton addTarget:self action:@selector(interestedButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.goingButton addTarget:self action:@selector(goingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.interestedLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewingActivity.numberInterested];
        cell.goingLabel.text = [NSString stringWithFormat:@"%ld", (long)self.viewingActivity.numberGoing];
        
        return cell;
    }
    
    if (indexPath.row == 3 && [self.viewingActivity.locationAddress isEqualToString:@""]) {
        WAViewActivityTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.discussionView.backgroundColor = ([self.viewingActivity.host isEqualToString:[FIRAuth auth].currentUser.uid]) ? [WAValues discussionColor] : [UIColor whiteColor];
        
        NSString *nameString = @"";
        
        if (self.userNamesDictionary[self.viewingActivity.host]) {
            nameString = self.userNamesDictionary[self.viewingActivity.host];
        }
        else {
            [self.userNamesDictionary setObject:@"" forKey:self.viewingActivity.host];
            
            [WAServer getUserBasicInfoWithID:self.viewingActivity.host completion:^ (NSDictionary *user) {
                NSLog(@"User Info: %@", user);
                
                [self.userNamesDictionary setObject:user[@"first_name"] forKey:self.viewingActivity.host];
                [self.tableView reloadData];
                
                [self loadProfileImageWithURL:user[@"profile_image_url"] forUID:self.viewingActivity.host];
            }];
        }
        
        cell.nameLabel.text = nameString;
        
        UIImage *profileImage = [UIImage imageNamed:@"BlankCircle"];
        
        if (self.profileImagesDictionary[self.viewingActivity.host]) {
            profileImage = self.profileImagesDictionary[self.viewingActivity.host];
        }
        
        cell.profileImageView.image = profileImage;
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 20;
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"h:mm aa"];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"M/d"];
        
        NSString *startTimeString = [formatter1 stringFromDate:self.viewingActivity.startTime];
        NSString *dateString = [formatter2 stringFromDate:self.viewingActivity.startTime];
        
        cell.discussionTextLabel.text = [NSString stringWithFormat:@"%@ %@ (%@) at %@!", [WAValues dayOfWeekFromDate:self.viewingActivity.startTime], startTimeString, dateString, self.viewingActivity.locationName];
        
        return cell;
    }
    else if (indexPath.row == 3) {
        
        WAViewActivityMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mapCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.discussionView.backgroundColor = ([self.viewingActivity.host isEqualToString:[FIRAuth auth].currentUser.uid]) ? [WAValues discussionColor] : [UIColor whiteColor];
        
        NSString *nameString = @"";
        
        if (self.userNamesDictionary[self.viewingActivity.host]) {
            nameString = self.userNamesDictionary[self.viewingActivity.host];
        }
        else {
            [self.userNamesDictionary setObject:@"" forKey:self.viewingActivity.host];
            
            [WAServer getUserBasicInfoWithID:self.viewingActivity.host completion:^ (NSDictionary *user) {
                NSLog(@"User Info: %@", user);
                
                [self.userNamesDictionary setObject:user[@"first_name"] forKey:self.viewingActivity.host];
                [self.tableView reloadData];
                
                [self loadProfileImageWithURL:user[@"profile_image_url"] forUID:self.viewingActivity.host];
            }];
        }
        
        cell.nameLabel.text = nameString;
        
        UIImage *profileImage = [UIImage imageNamed:@"BlankCircle"];
        
        if (self.profileImagesDictionary[self.viewingActivity.host]) {
            profileImage = self.profileImagesDictionary[self.viewingActivity.host];
        }
        
        cell.profileImageView.image = profileImage;
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 20;
        
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"h:mm aa"];
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"M/d"];
        
        NSString *startTimeString = [formatter1 stringFromDate:self.viewingActivity.startTime];
        NSString *dateString = [formatter2 stringFromDate:self.viewingActivity.startTime];
        
        cell.discussionTextLabel.text = [NSString stringWithFormat:@"%@ %@ (%@) at %@!", [WAValues dayOfWeekFromDate:self.viewingActivity.startTime], startTimeString, dateString, self.viewingActivity.locationName];
        
        cell.locationMapView.clipsToBounds = true;
        cell.locationMapView.layer.cornerRadius = 8.0;
        
        cell.locationMapView.userInteractionEnabled = false;
        
        GMSMarker *marker = [GMSMarker markerWithPosition:self.viewingActivity.location.coordinate];
        marker.title = self.viewingActivity.locationName;
        marker.map = cell.locationMapView;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.viewingActivity.location.coordinate zoom:16];
        [cell.locationMapView setCamera:camera];
        
        [cell.showMapButton addTarget:self action:@selector(showMapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == (4 + [self.discussions count])) {
        WAViewActivityPostDiscussionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postDiscussionCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.postTextView.scrollEnabled = false;
        cell.postTextView.delegate = self;
        
        NSLog(@"setup discussions cell: %@", self.discussionPostText);
        
        if ([self.discussionPostText isEqualToString:@""]) {
            cell.postTextView.textColor = [WAValues notSelectedTextColor];
            cell.postTextView.text = @"Type a message";
        }
        else {
            cell.postTextView.textColor = [WAValues selectedTextColor];
            cell.postTextView.text = self.discussionPostText;
        }
        
        [cell.postButton addTarget:self action:@selector(postButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.row == (5 + [self.discussions count])) {
        
        WAViewActivityExtraTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"extraCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.viewingActivity.host isEqualToString:[FIRAuth auth].currentUser.uid]) {
            [cell.extraButton setTitle:@"Delete Activity" forState:UIControlStateNormal];
        }
        else {
            [cell.extraButton setTitle:@"Flag Activity" forState:UIControlStateNormal];
        }
        
        [cell.extraButton addTarget:self action:@selector(extraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    WAViewActivityTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 1) {
        
        cell.discussionView.backgroundColor = ([self.viewingActivity.host isEqualToString:[FIRAuth auth].currentUser.uid]) ? [WAValues discussionColor] : [UIColor whiteColor];
        
        NSString *nameString = @"";
        
        if (self.userNamesDictionary[self.viewingActivity.host]) {
            nameString = self.userNamesDictionary[self.viewingActivity.host];
        }
        else {
            [self.userNamesDictionary setObject:@"" forKey:self.viewingActivity.host];
            
            [WAServer getUserBasicInfoWithID:self.viewingActivity.host completion:^ (NSDictionary *user) {
                NSLog(@"User Info: %@", user);
                
                [self.userNamesDictionary setObject:user[@"first_name"] forKey:self.viewingActivity.host];
                [self.tableView reloadData];
                
                [self loadProfileImageWithURL:user[@"profile_image_url"] forUID:self.viewingActivity.host];
            }];
        }
        
        cell.nameLabel.text = nameString;
        
        UIImage *profileImage = [UIImage imageNamed:@"BlankCircle"];
        
        if (self.profileImagesDictionary[self.viewingActivity.host]) {
            profileImage = self.profileImagesDictionary[self.viewingActivity.host];
        }
        
        cell.profileImageView.image = profileImage;
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 20;
        
        NSString *freeFoodString = (self.viewingActivity.freeFood) ? @"\nFree Food!" : @"";
        
        NSString *hostedByString = @"";
        
        if (![self.viewingActivity.hostGroupName isEqualToString:@""]) {
            hostedByString = [NSString stringWithFormat:@" (host by %@)", self.viewingActivity.hostGroupName];
        }
        
        cell.discussionTextLabel.text = [NSString stringWithFormat:@"%@%@%@", self.viewingActivity.title, hostedByString, freeFoodString];
    }
    else if (indexPath.row == 2) {
        
        cell.discussionView.backgroundColor = [UIColor whiteColor];
        
        cell.nameLabel.text = @"Judy";
        cell.discussionTextLabel.text = @"What time is it?";
        
        cell.profileImageView.image = [UIImage imageNamed:@"judy_image"];
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 20;
    }
    else {
        
        NSDictionary *discussion = [self.discussions objectAtIndex:indexPath.row - 4];
        
        cell.discussionTextLabel.text = discussion[@"text"];
        
        NSString *discussionUID = discussion[@"user_id"];
        
        cell.discussionView.backgroundColor = ([discussionUID isEqualToString:[FIRAuth auth].currentUser.uid]) ? [WAValues discussionColor] : [UIColor whiteColor];
        
        NSString *nameString = @"";
        
        if (self.userNamesDictionary[discussionUID]) {
            nameString = self.userNamesDictionary[discussionUID];
        }
        else {
            [self.userNamesDictionary setObject:@"" forKey:discussionUID];
            
            [WAServer getUserBasicInfoWithID:discussionUID completion:^ (NSDictionary *user) {
                NSLog(@"User Info: %@", user);
                
                [self.userNamesDictionary setObject:user[@"first_name"] forKey:discussionUID];
                [self.tableView reloadData];
                
                [self loadProfileImageWithURL:user[@"profile_image_url"] forUID:discussionUID];
            }];
        }
        
        cell.nameLabel.text = nameString;
        
        UIImage *profileImage = [UIImage imageNamed:@"BlankCircle"];
        
        if (self.profileImagesDictionary[discussionUID]) {
            profileImage = self.profileImagesDictionary[discussionUID];
        }
        
        cell.profileImageView.image = profileImage;
        cell.profileImageView.clipsToBounds = true;
        cell.profileImageView.layer.cornerRadius = 20;
    }
    
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
    
    label.text = @"Discussion";
    
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

# pragma mark - Button targets

- (void)showMapButtonPressed:(UIButton *)button {
    
    [self performSegueWithIdentifier:@"openShowMap" sender:self];
}


- (void)interestedButtonPressed:(UIButton *)button {
    
    if (![self.viewingActivity.interestedUserIDs containsObject:[FIRAuth auth].currentUser.uid]) {
        [WAServer activityInterested:[FIRAuth auth].currentUser.uid activityID:self.viewingActivity.activityID completion:nil];
        
        [self.viewingActivity.interestedUserIDs addObject:[FIRAuth auth].currentUser.uid];
        [self.viewingActivity.goingUserIDs removeObject:[FIRAuth auth].currentUser.uid];
    }
    else {
        [WAServer activityRemoveUser:[FIRAuth auth].currentUser.uid activityID:self.viewingActivity.activityID completion:nil];
        
        [self.viewingActivity.interestedUserIDs removeObject:[FIRAuth auth].currentUser.uid];
        [self.viewingActivity.goingUserIDs removeObject:[FIRAuth auth].currentUser.uid];
    }
    
    self.viewingActivity.numberInterested = [self.viewingActivity.interestedUserIDs count];
    self.viewingActivity.numberGoing = [self.viewingActivity.goingUserIDs count];
    
    [self.tableView reloadData];
}

- (void)goingButtonPressed:(UIButton *)button {
    
    if (![self.viewingActivity.goingUserIDs containsObject:[FIRAuth auth].currentUser.uid]) {
        [WAServer activityGoing:[FIRAuth auth].currentUser.uid activityID:self.viewingActivity.activityID completion:nil];
        
        [self.viewingActivity.interestedUserIDs removeObject:[FIRAuth auth].currentUser.uid];
        [self.viewingActivity.goingUserIDs addObject:[FIRAuth auth].currentUser.uid];
    }
    else {
        [WAServer activityRemoveUser:[FIRAuth auth].currentUser.uid activityID:self.viewingActivity.activityID completion:nil];
        
        [self.viewingActivity.interestedUserIDs removeObject:[FIRAuth auth].currentUser.uid];
        [self.viewingActivity.goingUserIDs removeObject:[FIRAuth auth].currentUser.uid];
    }
    
    self.viewingActivity.numberInterested = [self.viewingActivity.interestedUserIDs count];
    self.viewingActivity.numberGoing = [self.viewingActivity.goingUserIDs count];
    
    [self.tableView reloadData];
}

- (void)extraButtonPressed:(UIButton *)button {
    
    if ([self.viewingActivity.host isEqualToString:[FIRAuth auth].currentUser.uid]) {  // Delete event
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Activity" message:@"This action cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        UIAlertAction *option = [UIAlertAction actionWithTitle:@"Delete Activity" style:UIAlertActionStyleDestructive handler: ^(UIAlertAction *action){
            
            [WAServer deleteActivityWithID:self.viewingActivityID completion:^(BOOL sucess) {
                [self.navigationController popViewControllerAnimated:true];
            }];
            
        }];
        
        [alert addAction:option];
        
        [self presentViewController:alert animated:true completion:nil];
        
    }
    else {  // Flag event
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Flag Activity" message:@"We will determine if the activity should be removed from Walla once you flag this activity." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        UIAlertAction *option = [UIAlertAction actionWithTitle:@"Flag Activity" style:UIAlertActionStyleDestructive handler: ^(UIAlertAction *action){
            
            [WAServer flagActivity:self.viewingActivityID completion:^(BOOL success) {
                UIAlertController *flagAlert = [UIAlertController alertControllerWithTitle:@"Activity Flagged" message:@"The activity has been flagged for review." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                
                [flagAlert addAction:cancelAction];
                
                [self presentViewController:flagAlert animated:true completion:nil];
            }];
            
        }];
        
        [alert addAction:option];
        
        [self presentViewController:alert animated:true completion:nil];
        
    }
    
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([self.discussionPostText isEqualToString:@""]) {
        textView.textColor = [WAValues selectedTextColor];
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.discussionPostText = textView.text;
    
    if ([self.discussionPostText isEqualToString:@""]) {
        textView.textColor = [WAValues notSelectedTextColor];
        textView.text = @"Type a message";
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.discussionPostText = textView.text;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - Post discussion

- (void)postButtonPressed:(UIButton *)button {
    
    NSLog(@"postButtonPressed");
    
    WAViewActivityPostDiscussionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 + [self.discussions count] inSection:0]];
    
    [cell.postTextView resignFirstResponder];
    
    if (!self.userVerified) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Account not Verified" message:@"You cannot post in discussions until your account has been verified. Open the verification link to verify your account. If you have not received a verification link, you can request one now." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *requestAction = [UIAlertAction actionWithTitle:@"Request Verification Link" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            self.tableView.userInteractionEnabled = false;
            
            [WAServer sendVerificationEmail:^(BOOL success) {
                
                self.tableView.userInteractionEnabled = true;
                
                if (success) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Sent" message:@"We have sent you a verification email. Please open the verification link." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:true completion:nil];
                }
            }];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:requestAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }
    else if ([self.discussionPostText isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Text" message:@"You must write something before you can join the discussion." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:true completion:nil];
    }
    else {
        
        [WAServer postDiscussion:self.discussionPostText activityID:self.viewingActivityID completion:^(BOOL success) {
            if (success) {
                [self loadDiscussions];
            }
        }];
        
        self.discussionPostText = @"";
        
        NSLog(@"Reset discussions text: %@", self.discussionPostText);
        
        [self.tableView reloadData];
    }
    
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
