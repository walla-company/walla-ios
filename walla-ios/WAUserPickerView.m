//
//  WAUserPickerView.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/25/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAUserPickerView.h"

@import Firebase;

@implementation WAUserPickerView

static CGFloat VIEW_HEIGHT = 360.0; // 300 for primary
static CGFloat PRIMARY_VIEW_HEIGHT = 300.0; //VIEW_HEIGHT - secondary view height
static CGFloat VIEW_WIDTH = 320.0;

# pragma mark - Initialization

- (void)initialize:(NSString *)title {
    
    self.usersDictionary = [[NSMutableDictionary alloc] init];
    self.userProfileImageDictionary = [[NSMutableDictionary alloc] init];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.primaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT-60.0)];
    self.secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-50.0, VIEW_WIDTH, 40.0)];
    
    self.primaryView.backgroundColor = [UIColor whiteColor];
    self.primaryView.layer.cornerRadius = 15.0;
    
    self.secondaryView.backgroundColor = [UIColor whiteColor];
    self.secondaryView.layer.cornerRadius = 15.0;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, VIEW_WIDTH, 25)];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    
    UIView *separaterView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, VIEW_WIDTH, 0.5)];
    separaterView.backgroundColor = [UIColor lightGrayColor];
    
    self.usersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, VIEW_WIDTH, PRIMARY_VIEW_HEIGHT-60) style:UITableViewStylePlain];
    
    self.usersTableView.showsVerticalScrollIndicator = false;
    
    self.usersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.usersTableView registerNib:[UINib nibWithNibName:@"WAUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
    
    self.usersTableView.rowHeight = UITableViewAutomaticDimension;
    self.usersTableView.estimatedRowHeight = 44.0;
    
    self.usersTableView.delegate = self;
    self.usersTableView.dataSource = self;
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.doneButton.frame = CGRectMake(0.0, 10.0, VIEW_WIDTH, 20.0);
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.primaryView];
    [self addSubview:self.secondaryView];
    
    [self.primaryView addSubview:self.titleLabel];
    [self.primaryView addSubview:separaterView];
    [self.primaryView addSubview:self.usersTableView];
    [self.primaryView addSubview:self.doneButton];
    
    [self.secondaryView addSubview:self.doneButton];
    
}

- (id)initWithSuperViewFrame:(CGRect)frame title:(NSString *)title selectedUsers:(NSArray *)selectedUsers userFriendIDs:(NSArray *)userFriendIDs {
    
    self = [super initWithFrame:CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height, VIEW_WIDTH, VIEW_HEIGHT)];
    
    self.userFriendIDs = userFriendIDs;
    
    self.selectedUsers = [[NSMutableArray alloc] init];
    
    for (NSDictionary *user in selectedUsers) {
        [self.selectedUsers addObject:user[@"user_id"]];
    }
    
    if (self) {
        [self initialize:title];
    }
    
    return self;
}

- (void)animateUp:(CGRect)frame {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.frame = CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height-VIEW_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT);
                         
                     }
                     completion:nil];
}

- (void)animateDown:(CGRect)frame completion:(animationCompletion) completionBlock {
    
    [UIView animateWithDuration:0.25
                          delay:0.0
         usingSpringWithDamping:100.0
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.frame = CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height, VIEW_WIDTH, VIEW_HEIGHT);
                         
                     }
                     completion:^(BOOL finished){
                         completionBlock();
                     }];
}

# pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.userFriendIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WAUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    NSString *userID = [self.userFriendIDs objectAtIndex:indexPath.row];
    
    NSDictionary *user = [self.usersDictionary objectForKey:userID];
    
    cell.profileImageView.clipsToBounds = true;
    cell.profileImageView.layer.cornerRadius = 17.5;
    
    if (user) {
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", user[@"name"]];
        
        cell.infoLabel.text = [NSString stringWithFormat:@"%@ Class of %@ / %@", ([user[@"academic_level"] isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Grad/Prof", user[@"graduation_year"], user[@"major"]];
        
        cell.profileImageView.image = [self.userProfileImageDictionary objectForKey:userID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([self.selectedUsers containsObject:userID]) {
            cell.backgroundColor = [WAValues selectedCellColor];
        }
        else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    else {
        
        cell.nameLabel.text = @"";
        cell.infoLabel.text = @"";
        cell.profileImageView.image = [UIImage imageNamed:@"BlankCircle"];
        cell.backgroundColor = [UIColor whiteColor];
        
        [self.usersDictionary setObject:@{@"name": @"", @"graduation_year": @"", @"major": @"", @"academic_level": @"", @"hometown": @"", @"profile_image_url": @"", @"user_id": userID} forKey:userID];
        
        [self.userProfileImageDictionary setObject:[UIImage imageNamed:@"BlankCircle"] forKey:userID];
        
        [WAServer getUserBasicInfoWithID:userID completion:^(NSDictionary *user) {
            [self.usersDictionary setObject:user forKey:userID];
            [self.usersTableView reloadData];
            [self loadProfileImage:user[@"profile_image_url"] forUserID:userID];
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *userID = [self.userFriendIDs objectAtIndex:indexPath.row];
    
    if (![self.selectedUsers containsObject:userID]){
        [self.selectedUsers addObject:userID];
    }
    else {
        [self.selectedUsers removeObject:userID];
    }
    
    [self.usersTableView reloadData];
    
    NSMutableArray *selectedUsersInfo = [[NSMutableArray alloc] init];
    
    for (NSString *userID in self.selectedUsers) {
        NSDictionary *user = [self.usersDictionary objectForKey:userID];
        [selectedUsersInfo addObject:user];
    }
    
    [self.delegate usersChanges:selectedUsersInfo];
}

- (void)loadProfileImage:(NSString *)profileImageURL forUserID:(NSString *)userID {
    
    if (![profileImageURL isEqualToString:@""]) {
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:profileImageURL];
        
        [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Error downloading profile image: %@", error);
                
            } else {
                
                [self.userProfileImageDictionary setObject:[UIImage imageWithData:data] forKey:userID];
                [self.usersTableView reloadData];
            }
        }];
    }
}

# pragma mark - Delgate

- (void)doneButtonPressed {
    
    [self.delegate doneButtonPressed];
}

@end
