//
//  WADiscoverViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WADiscoverViewController.h"

#import "WAViewUserTableViewController.h"
#import "WAViewGroupTableViewController.h"

#import "WAUserTableViewCell.h"
#import "WAGroupTableViewCell.h"

#import "WAServer.h"
#import "WAGroup.h"

#import "WAValues.h"

@import  Firebase;

@interface WADiscoverViewController ()

@end

@implementation WADiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CreateNewEvent"] style:UIBarButtonItemStylePlain target:self action:@selector(openCreateActivity)];
    
    // Set up table view
    
    self.discoverTableView.delegate = self;
    self.discoverTableView.dataSource = self;
    
    self.discoverTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.discoverTableView registerNib:[UINib nibWithNibName:@"WADiscoverFriendSuggestionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendSuggestionsCell"];
    [self.discoverTableView registerNib:[UINib nibWithNibName:@"WADiscoverSuggestedGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"suggestedGroupCell"];
    
    [self.discoverTableView registerNib:[UINib nibWithNibName:@"WAUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
    [self.discoverTableView registerNib:[UINib nibWithNibName:@"WAGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"groupCell"];
    
    self.discoverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.discoverTableView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    self.discoverTableView.showsVerticalScrollIndicator = false;
    
    self.discoverTableView.rowHeight = UITableViewAutomaticDimension;
    self.discoverTableView.estimatedRowHeight = 100.0;
    
    // Load suggested groups
    /*
    [WAServer getSuggestedGroups:^(NSArray *groups) {
        self.suggestedGroups = groups;
        [self.discoverTableView reloadData];
    }];*/
    
    [WAServer getGroups:^(NSArray *groups) {
        self.allGroups = groups;
        
        self.allGroups = [self.allGroups sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = ((WAGroup *)a).name;
            NSString *second = ((WAGroup *)b).name;
            return [first compare:second options:NSCaseInsensitiveSearch];
        }];
        
        [self.discoverTableView reloadData];
    }];
    
    // Set up search
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.placeholder = @"Search here...";
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.discoverTableView.tableHeaderView = self.searchController.searchBar;
    
    self.shouldShowSearchResults = false;
    
    // Initialize default values
    
    self.filteredUserArray = [[NSMutableArray alloc] init];
    self.filteredGroupArray = [[NSMutableArray alloc] init];
    
    self.userInfoDictionary = [[NSMutableDictionary alloc] init];
    self.userProfileImageDictionary = [[NSMutableDictionary alloc] init];
    self.groupsDictionary = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getSearchUserDictionary:^(NSDictionary *users) {
        self.searchUsersDictionary = users;
    }];
    
    [WAServer getSearchGroupDictionary:^(NSDictionary *groups) {
        self.searchGroupsDictionary = groups;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.shouldShowSearchResults) {
    
        NSLog(@"self.filteredUserArray: %@", self.filteredUserArray);
        
        return (section == 0) ? [self.filteredUserArray count] : [self.filteredGroupArray count];
    }
    
    if (section == 0) return 1;
    
    //return [self.suggestedGroups count];
    return [self.allGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.shouldShowSearchResults) {
        
        if (indexPath.section == 0) {
            WAUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *uid = [self.filteredUserArray objectAtIndex:indexPath.row];
            
            NSDictionary *user = [self.userInfoDictionary objectForKey:uid];
            
            cell.profileImageView.clipsToBounds = true;
            cell.profileImageView.layer.cornerRadius = 17.5;
            
            UIImage *profileImage = [self.userProfileImageDictionary objectForKey:uid];
            
            if (profileImage) {
                cell.profileImageView.image = profileImage;
            }
            else {
                [self.userProfileImageDictionary setObject:[UIImage imageNamed:@"BlankCircle"] forKey:uid];
                cell.profileImageView.image = [UIImage imageNamed:@"BlankCircle"];
            }
            
            if (user) {
                cell.nameLabel.text = user[@"name"];
                cell.infoLabel.text = [NSString stringWithFormat:@"%@ Class of %@", ([user[@"academic_level"] isEqualToString:@"undergrad"]) ? @"Undergraduate" : @"Graduate", user[@"graduation_year"]];
            }
            else {
                cell.nameLabel.text = @"";
                cell.infoLabel.text = @"";
                
                [self.userInfoDictionary setObject:@{@"name": @"", @"academic_level": @"", @"graduation_year": @""} forKey:uid];
                
                [WAServer getUserBasicInfoWithID:uid completion:^(NSDictionary *user) {
                    [self.userInfoDictionary setObject:user forKey:uid];
                    [self loadProfileImage:user[@"profile_image_url"] forUserID:uid];
                    [self.discoverTableView reloadData];
                }];
            }
            
            return cell;
        }
        
        WAGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *guid = [self.filteredGroupArray objectAtIndex:indexPath.row];
        
        NSDictionary *group = [self.groupsDictionary objectForKey:guid];
        
        cell.groupTagView.layer.cornerRadius = 8.0;
        
        if (group) {
            cell.groupNameLabel.text = group[@"name"];
            cell.groupTagView.backgroundColor = [WAValues colorFromHexString:group[@"color"]];
            cell.groupTagViewLabel.text = group[@"short_name"];
        }
        else {
            cell.groupNameLabel.text = @"";
            cell.groupTagView.backgroundColor = [UIColor whiteColor];
            cell.groupNameLabel.text = @"";
            
            [self.groupsDictionary setObject:@{@"name": @"", @"short_name": @"", @"color": @"#ffffff", @"group_id": guid} forKey:guid];
            
            [WAServer getGroupBasicInfoWithID:guid completion:^(NSDictionary *group) {
                [self.groupsDictionary setObject:group forKey:guid];
                [self.discoverTableView reloadData];
            }];
        }
        
        return cell;
    }
    
    if (indexPath.section == 0) {
        
        WADiscoverFriendSuggestionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendSuggestionsCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        return cell;
    }
    
    WADiscoverSuggestedGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"suggestedGroupCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.groupTagView.layer.cornerRadius = 8.0;
    cell.groupTagView.clipsToBounds = false;
    
    //WAGroup *group = [self.suggestedGroups objectAtIndex:indexPath.row];
    
    WAGroup *group = [self.allGroups objectAtIndex:indexPath.row];
    
    cell.groupTagViewLabel.text = group.shortName;
    cell.groupTagView.backgroundColor = group.groupColor;
    
    cell.groupInfoLabel.text = [NSString stringWithFormat:@"%ld members", (unsigned long)[group.members count]];
    
    cell.groupNameLabel.text = group.name;
    
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
                
                [self.userProfileImageDictionary setObject:[UIImage imageWithData:data] forKey:userID];
                [self.discoverTableView reloadData];
            }
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.discoverTableView.frame.size.width, 30)];
    
    headerView.backgroundColor = [[UIColor alloc] initWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, self.discoverTableView.frame.size.width-30, 30)];
    
    label.textColor = [UIColor colorWithRed:143./255.0 green:142./255.0 blue:148./255.0 alpha:1.0];
    
    if (self.shouldShowSearchResults) {
        label.text = (section == 0) ? @"Users" : @"Groups";
    }
    else {
        //label.text = (section == 0) ? @"Suggested friends" : @"Suggested groups";
        label.text = (section == 0) ? @"Suggested friends" : @"All groups";
    }
    
    label.font = [UIFont systemFontOfSize:14.0];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.shouldShowSearchResults) {
        if (indexPath.section == 1) {
            
            //WAGroup *group = [self.suggestedGroups objectAtIndex:indexPath.row];
            
            WAGroup *group = [self.allGroups objectAtIndex:indexPath.row];
            
            self.openGroupID = group.groupID;
            
            [self performSegueWithIdentifier:@"openViewGroup" sender:self];
        }
    }
    else {
        
        if (indexPath.section == 0) {
            
            self.openUserID = [self.filteredUserArray objectAtIndex:indexPath.row];
            
            [self performSegueWithIdentifier:@"openViewUser" sender:self];
        }
        else {
            self.openGroupID = [self.filteredGroupArray objectAtIndex:indexPath.row];
            
            [self performSegueWithIdentifier:@"openViewGroup" sender:self];
        }
        
        [self.searchController setActive:false];
    }
    
}

#pragma mark - Search bar

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar.text uppercaseString];
    
    [self.filteredUserArray removeAllObjects];
    [self.filteredGroupArray removeAllObjects];
    
    for (NSString *uid in [self.searchUsersDictionary allKeys]) {
        
        NSString *compareString = [[self.searchUsersDictionary objectForKey:uid] uppercaseString];
        
        if ([compareString rangeOfString:searchString].location != NSNotFound && ![uid isEqualToString:[FIRAuth auth].currentUser.uid]) {
            [self.filteredUserArray addObject:uid];
        }
        
    }
    
    for (NSString *guid in [self.searchGroupsDictionary allKeys]) {
        
        NSString *compareString = [[self.searchGroupsDictionary objectForKey:guid] uppercaseString];
        
        if ([compareString rangeOfString:searchString].location != NSNotFound) {
            [self.filteredGroupArray addObject:guid];
        }
        
    }
    
    [self.discoverTableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = true;
    self.discoverTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.discoverTableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = false;
    self.discoverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.discoverTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = false;
    self.discoverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.discoverTableView reloadData];
    
    [self.searchController.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = true;
    self.discoverTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.discoverTableView reloadData];
    
    [self.searchController.searchBar resignFirstResponder];
}

#pragma mark - Suggested users cell delegate

- (void)suggestedUserSelected:(NSString *)userID {
    
    NSLog(@"SELECTED: %@", userID);
    
    self.openUserID = userID;
    
    [self performSegueWithIdentifier:@"openViewUser" sender:self];
}

#pragma mark - Navigation

- (void)openCreateActivity {
    
    [self performSegueWithIdentifier:@"openCreateActivity" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openViewUser"]) {
        
        WAViewUserTableViewController *destinationController = (WAViewUserTableViewController *) [segue destinationViewController];
        destinationController.viewingUserID = self.openUserID;
    }
    else if ([segue.identifier isEqualToString:@"openViewGroup"]) {
        WAViewGroupTableViewController *destinationController = (WAViewGroupTableViewController *) [segue destinationViewController];
        destinationController.viewingGroupID = self.openGroupID;
    }
}

@end
