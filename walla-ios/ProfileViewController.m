//
//  ProfileViewController.m
//  walla-ios
//
//  Created by Stas Tomych on 8/8/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "ProfileViewController.h"
#import "WAServer.h"

@import Firebase;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100; // Something reasonable to help ios render your cells
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserWithID:[FIRAuth auth].currentUser.uid completion:^(WAUser *user) {
        
        self.user = user;
        
       // [self.tableView reloadData];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
