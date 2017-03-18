//
//  WAIntroViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 3/17/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "WAIntroViewController.h"

@interface WAIntroViewController ()

@end

@implementation WAIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextButtonView.clipsToBounds = true;
    self.nextButtonView.layer.cornerRadius = 17.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender {
    
    [self performSegueWithIdentifier:@"showNext" sender:self];
}

@end
