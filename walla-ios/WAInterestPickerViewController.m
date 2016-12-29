//
//  WAInterestPickerViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/28/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAInterestPickerViewController.h"

@interface WAInterestPickerViewController ()

@end

@implementation WAInterestPickerViewController

- (id)initWithTitle:(NSString *)title selectedInterests:(NSArray *)selectedInterests maxInterests:(NSInteger)maxInterests {
    
    self = [super init];
    
    if (self) {
        self.interestPickerTitle = title;
        self.selectedInterests = selectedInterests;
        self.maxInterests = maxInterests;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the interests picker view
    
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.frame];
    
    tapView.tag = 100;
    
    [self.view addSubview:tapView];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [self.view addGestureRecognizer:singleFingerTap];
    
    self.interestPicker = [[WAInterestPickerView alloc] initWithSuperViewFrame:self.view.frame title:self.interestPickerTitle selectedInterests:self.selectedInterests maxInterests:self.maxInterests];
    
    self.interestPicker.delegate = self;
    
    [self.view addSubview:self.interestPicker];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.interestPicker animateUp:self.view.frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view.tag == 100) {
        
        return true;
    }
    
    return false;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    
    UIView *tappedView = [self.view hitTest:location withEvent:nil];
    
    if (tappedView.tag == 100) {
        
        [self doneButtonPressed];
    }
}

# pragma mark - User picker delegate

- (void)doneButtonPressed {
    
    [self.interestPicker animateDown:self.view.frame completion:^{
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}

- (void)interestsChanged:(NSArray *)interests {
    
    [self.delegate intersPickerViewUserSelected:interests tag:self.view.tag];
}

@end
