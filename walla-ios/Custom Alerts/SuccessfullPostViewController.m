//
//  SuccessFulPostViewController.m
//  walla-ios
//
//  Created by Stas Tomych on 8/12/17.
//  Copyright © 2017 GenieUS, Inc. All rights reserved.
//

#import "SuccessfullPostViewController.h"

double const AlertDisplayAnimation = 1.5f;

@interface SuccessfullPostViewController ()

@end

@implementation SuccessfullPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)presentFromViewController:(UIViewController *)viewController {
    UIStoryboard *alerts = [UIStoryboard storyboardWithName:@"Alerts" bundle:[NSBundle mainBundle]];
                                                                              
    SuccessfullPostViewController *alert = [alerts instantiateViewControllerWithIdentifier:NSStringFromClass([SuccessfullPostViewController class])];
    
    viewController.definesPresentationContext = YES;
    alert.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [viewController presentViewController:alert animated:YES completion:nil];
    
    __weak SuccessfullPostViewController *weakAlert = alert;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(AlertDisplayAnimation * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakAlert dismissViewControllerAnimated:YES completion:nil];
    });

}

@end
