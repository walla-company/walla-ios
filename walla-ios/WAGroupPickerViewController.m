//
//  WAGroupPickerViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/23/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAGroupPickerViewController.h"

@interface WAGroupPickerViewController ()

@end

@implementation WAGroupPickerViewController

- (id)initWithTitle:(NSString *)title selectedGroups:(NSArray *)selectedGroups userGroupIDs:(NSArray *)userGroupIDs canSelectMultipleGourps:(BOOL)canSelectMultipleGourps {
    
    self = [super init];
    
    if (self) {
        self.groupPickerTitle = title;
        self.selectedGroups = selectedGroups;
        self.userGroupIDs = userGroupIDs;
        self.canSelectMultipleGourps = canSelectMultipleGourps;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the group picker view
    
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.frame];
    
    tapView.tag = 100;
    
    [self.view addSubview:tapView];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [self.view addGestureRecognizer:singleFingerTap];
    
    self.groupPicker = [[WAGroupPickerView alloc] initWithSuperViewFrame:self.view.frame title:self.groupPickerTitle selectedGroups:self.selectedGroups userGroupIDs:self.userGroupIDs canSelectMultipleGroups:self.canSelectMultipleGourps];
    
    self.groupPicker.delegate = self;
    
    [self.view addSubview:self.groupPicker];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.groupPicker animateUp:self.view.frame];
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

# pragma mark - Group picker delegate

- (void)doneButtonPressed {
    
    [self.groupPicker animateDown:self.view.frame completion:^{
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}

- (void)groupsChanged:(NSArray *)groups {
    
    [self.delegate groupPickerViewGroupSelected:groups tag:self.view.tag];
}

@end
