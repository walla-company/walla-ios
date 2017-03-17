//
//  WAAddGroupTableViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAAddGroupTableViewController.h"

#import "WAAddGroupTableViewCell.h"

#import "WAServer.h"

#import "WAValues.h"

@interface WAAddGroupTableViewController ()

@end

@implementation WAAddGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Group";
    
    // Set up table view
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WAAddGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"addGroupCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.showsVerticalScrollIndicator = false;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    
    
    [WAServer getSearchGroupDictionary:^(NSDictionary *groups) {
        
        NSLog(@"Search Groups: %@", groups);
        
        NSMutableArray *groupsArray = [[NSMutableArray alloc] init];
        
        for (NSString *key in [groups allKeys]) {
            [groupsArray addObject:@[key, groups[key]]];
        }
        
        NSLog(@"All groups array: %@", self.allGroupsArray);
        
        self.allGroupsArray = [groupsArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = a[1];
            NSString *second = b[1];
            return [first compare:second options:NSCaseInsensitiveSearch];
        }];
        
        [self.tableView reloadData];
    }];
    
    /*
    [WAServer getGroups:^(NSArray *groups) {
        self.allGroups = groups;
        
        NSLog(@"All Groups: %@", groups);
        
        self.allGroups = [self.allGroups sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = ((WAGroup *)a).name;
            NSString *second = ((WAGroup *)b).name;
            return [first compare:second options:NSCaseInsensitiveSearch];
        }];
        
        [self.tableView reloadData];
    }];
    */
    // Set up search
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.placeholder = @"Search for group...";
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.shouldShowSearchResults = false;
    
    // Initialize default values
    
    self.filteredGroupArray = [[NSMutableArray alloc] init];
    
    self.groupsDictionary = [[NSMutableDictionary alloc] init];
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
    
    if (self.shouldShowSearchResults) return [self.filteredGroupArray count];
    
    return [self.allGroupsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *groupID;
    
    if (self.shouldShowSearchResults) groupID = self.filteredGroupArray[indexPath.row];
    else groupID = self.allGroupsArray[indexPath.row][0];
    
    WAAddGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addGroupCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.groupsDictionary[groupID]) {
        NSDictionary *group = self.groupsDictionary[groupID];
        
        cell.groupNameLabel.text = group[@"name"];
        cell.groupTagViewLabel.text = group[@"short_name"];
        cell.groupTagView.backgroundColor = [WAValues colorFromHexString:group[@"color"]];
        
        long numberOfMembers = [group[@"member_count"] integerValue];
        
        cell.groupInfoLabel.text = [NSString stringWithFormat:@"%ld %@", numberOfMembers, (numberOfMembers == 1) ? @"member" : @"members"];
    }
    else {
        cell.groupTagView.backgroundColor = [UIColor whiteColor];
        cell.groupTagViewLabel.text = @"";
        cell.groupNameLabel.text = @"";
        cell.groupInfoLabel.text = @"";
        [self.groupsDictionary setObject:@{@"name": @"", @"short_name": @"", @"color": @"#ffffff", @"member_count": @0} forKey:groupID];
        [WAServer getGroupBasicInfoWithID:groupID completion:^(NSDictionary *group) {
            
            [self.groupsDictionary setObject:group forKey:groupID];
            
            [self.tableView reloadData];
        }];
    }
    
    [cell.addButton addTarget:self action:@selector(addGroupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.addButton.tag = indexPath.row;
    
    return cell;
}

- (void)addGroupButtonPressed:(UIButton *)button {
    
    NSString *groupID;
    if (self.shouldShowSearchResults) groupID = self.filteredGroupArray[button.tag];
    else groupID = self.allGroupsArray[button.tag][0];
    
    [WAServer joinGroup:groupID completion:^(BOOL success) {
        
        [self.searchController.searchBar resignFirstResponder];
        
        self.searchController.active = false;
        
        [self.navigationController popViewControllerAnimated:true];
    }];
    
}

#pragma mark - Search bar

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar.text uppercaseString];
    
    [self.filteredGroupArray removeAllObjects];
    
    for (NSArray *group in self.allGroupsArray) {
        
        NSString *compareString = [group[1] uppercaseString];
        
        if ([compareString rangeOfString:searchString].location != NSNotFound) {
            [self.filteredGroupArray addObject:group[0]];
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = true;
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = false;
    
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = false;
    
    [self.tableView reloadData];
    
    [self.searchController.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.shouldShowSearchResults = true;
    
    [self.tableView reloadData];
    
    [self.searchController.searchBar resignFirstResponder];
}


@end
