//
//  WAUserPickerViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/25/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAUserPickerViewController.h"

@interface WAUserPickerViewController ()

@end

@implementation WAUserPickerViewController

- (id)initWithTitle:(NSString *)title selectedUsers:(NSArray *)selectedUsers userFriendIDs:(NSArray *)userFriendIDs {
    
    self = [super init];
    
    if (self) {
        self.userPickerTitle = title;
        self.selectedUsers = selectedUsers;
        self.userFriendIDs = userFriendIDs;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add the user picker view
    
    UIView *tapView = [[UIView alloc] initWithFrame:self.view.frame];
    
    tapView.tag = 100;
    
    [self.view addSubview:tapView];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.delegate = self;
    [self.view addGestureRecognizer:singleFingerTap];
    
    self.userPicker = [[WAUserPickerView alloc] initWithSuperViewFrame:self.view.frame title:self.userPickerTitle selectedUsers:self.selectedUsers userFriendIDs:self.userFriendIDs];
    
    self.userPicker.delegate = self;
    
    [self.view addSubview:self.userPicker];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.userPicker animateUp:self.view.frame];
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
    
    [self.userPicker animateDown:self.view.frame completion:^{
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}

- (void)usersChanges:(NSArray *)users {
    
    [self.delegate userPickerViewUserSelected:users tag:self.view.tag];
}

@end
