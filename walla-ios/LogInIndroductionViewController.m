//
//  LogInIndroductionViewController.m
//  walla-ios
//
//  Created by Stas Tomych on 8/13/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "LogInIndroductionViewController.h"

@interface LogInIndroductionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation LogInIndroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.logInButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logInButton.layer.borderWidth = 2.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
