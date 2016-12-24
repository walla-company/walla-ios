//
//  WADatePickerViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/18/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WADatePickerView.h"

@protocol WADatePickerViewControllerDelegate <NSObject>

- (void)datePickerViewDateChanged:(NSDate *) date tag:(NSInteger)tag;

@end

@interface WADatePickerViewController : UIViewController <WADatePickerViewDelegate>

@property WADatePickerView *datePicker;

@property id <WADatePickerViewControllerDelegate> delegate;

@property NSString *datePickerTitle;
@property NSDate *datePickerDate;

- (id)initWithTitle:(NSString *)title date:(NSDate *)date;

- (void)setTitle:(NSString *)title;

- (void)setDate:(NSDate *)date;

@end
