//
//  WAInterestPickerViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/28/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAInterestPickerView.h"

@protocol WAInterestPickerViewControllerDelegate <NSObject>

- (void)intersPickerViewUserSelected:(NSArray *)interests tag:(NSInteger)tag;

@end

@interface WAInterestPickerViewController : UIViewController <WAInterestPickerViewDelegate, UIGestureRecognizerDelegate>

@property WAInterestPickerView *interestPicker;

@property id <WAInterestPickerViewControllerDelegate> delegate;

@property NSString *interestPickerTitle;
@property NSArray *selectedInterests;
@property NSInteger maxInterests;

- (id)initWithTitle:(NSString *)title selectedInterests:(NSArray *)selectedInterests maxInterests:(NSInteger)maxInterests;

@end
