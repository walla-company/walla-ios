//
//  WADatePickerViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/18/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WADatePickerViewController.h"

@interface WADatePickerViewController ()

@end

@implementation WADatePickerViewController

- (id)initWithTitle:(NSString *)title date:(NSDate *)date {
    
    self = [super init];
    
    if (self) {
        self.datePickerTitle = title;
        self.datePickerDate = date;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the date picker view
    
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.frame];
    
    tapView.tag = 100;
    
    [self.view addSubview:tapView];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    self.datePicker = [[WADatePickerView alloc] initWithSuperViewFrame:self.view.frame title:self.datePickerTitle date:self.datePickerDate];
    
    self.datePicker.delegate = self;
    
    [self.view addSubview:self.datePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    
    UIView *tappedView = [self.view hitTest:location withEvent:nil];
    
    if (tappedView.tag == 100) {
        
        [self doneButtonPressed];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.datePicker animateUp:self.view.frame];
}

- (void)setTitle:(NSString *)title {
    
    [self.datePicker setTitle:title];
}

- (void)setDate:(NSDate *)date {
    
    [self.datePicker setDate:date];
}

# pragma mark - Date picker delegate

- (void)doneButtonPressed {
    
    [self.datePicker animateDown:self.view.frame completion:^{
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}

- (void)dateChanged:(NSDate *)date {
    
    [self.delegate datePickerViewDateChanged:date tag:self.view.tag];
}

@end
