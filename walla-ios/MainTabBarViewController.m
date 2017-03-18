//
//  MainTabBarViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"viewWillAppear tabbar controller");
    
    [super viewWillAppear:animated];
    
    BOOL openEditProfile = [[NSUserDefaults standardUserDefaults] boolForKey:@"openEditProfile"];
    
    if (openEditProfile) {
        
        self.selectedIndex = 2;
    }
}

@end
