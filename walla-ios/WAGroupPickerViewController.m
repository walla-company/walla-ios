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

- (id)initWithTitle:(NSString *)title selectedGroups:(NSArray *)selectedGroups allGroups:(NSArray *)allGroups {
    
    self = [super init];
    
    if (self) {
        self.groupPickerTitle = title;
        self.selectedGroups = selectedGroups;
        self.allGroups = allGroups;
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
    [self.view addGestureRecognizer:singleFingerTap];
    
    self.groupPicker = [[WAGroupPickerView alloc] initWithSuperViewFrame:self.view.frame title:self.groupPickerTitle selectedGroups:self.selectedGroups allGroups:self.allGroups];
    
    self.groupPicker.delegate = self;
    
    [self.view addSubview:self.groupPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    
    UIView *tappedView = [self.view hitTest:location withEvent:nil];
    
    if (tappedView.tag == 100) {
        
        //[self doneButtonPressed];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.groupPicker animateUp:self.view.frame];
}

- (void)setTitle:(NSString *)title {
    
    [self.groupPicker setTitle:title];
}

- (void)setSelectedGroupsArray:(NSArray *)groups {
    
    [self.groupPicker setSelectedGroupsArray:groups];
}

- (void)setCanSelectMultipleGroups:(BOOL)canSelectMultipleGroups {
    
    [self.groupPicker canSelectMultipleGroups:canSelectMultipleGroups];
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
