//
//  WAIntroCompleteViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAIntroCompleteViewController.h"

#import "WAServer.h"

@interface WAIntroCompleteViewController ()

@end

@implementation WAIntroCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.completeButtonView.clipsToBounds = true;
    self.completeButtonView.layer.cornerRadius = 17.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)complete:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"openEditProfile"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [WAServer userIntroComplete:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
