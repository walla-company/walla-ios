//
//  WADatePickerView.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/18/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WADatePickerView.h"

@implementation WADatePickerView

static CGFloat VIEW_HEIGHT = 360.0; // 300 for primary
static CGFloat PRIMARY_VIEW_HEIGHT = 300.0; //VIEW_HEIGHT - secondary view height
static CGFloat VIEW_WIDTH = 320.0;

# pragma mark - Initialization

- (void)initialize:(NSString *)title date:(NSDate *)date {
    
    //self.layer.cornerRadius = 15.0;
    //self.backgroundColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.primaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT-60.0)];
    self.secondaryView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-50.0, VIEW_WIDTH, 40.0)];
    
    self.primaryView.backgroundColor = [UIColor whiteColor];
    self.primaryView.layer.cornerRadius = 15.0;
    
    self.secondaryView.backgroundColor = [UIColor whiteColor];
    self.secondaryView.layer.cornerRadius = 15.0;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, VIEW_WIDTH, 25)];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    
    UIView *separaterView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, VIEW_WIDTH, 0.5)];
    separaterView.backgroundColor = [UIColor lightGrayColor];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, VIEW_WIDTH, PRIMARY_VIEW_HEIGHT-50)];
    
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minuteInterval = 1;
    self.datePicker.date = [NSDate new];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:[NSDate new].timeIntervalSince1970];
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.datePicker.date = date;
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.doneButton.frame = CGRectMake(0.0, 10.0, VIEW_WIDTH, 20.0);
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.primaryView];
    [self addSubview:self.secondaryView];
    
    [self.primaryView addSubview:self.titleLabel];
    [self.primaryView addSubview:separaterView];
    [self.primaryView addSubview:self.datePicker];
    [self.primaryView addSubview:self.doneButton];
    
    [self.secondaryView addSubview:self.doneButton];
    
}

- (id)initWithSuperViewFrame:(CGRect)frame title:(NSString *)title date:(NSDate *)date {
    
    self = [super initWithFrame:CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height, VIEW_WIDTH, VIEW_HEIGHT)];
    
    if (self) {
        [self initialize:title date:date];
    }
    
    return self;
    
}

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

-(void)setDate:(NSDate *)date {
    
    self.datePicker.date = date;
}

- (void)animateUp:(CGRect)frame {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.frame = CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height-VIEW_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT);
                         
                     }
                     completion:nil];
}

- (void)animateDown:(CGRect)frame completion:(animationCompletion) completionBlock {
    
    [UIView animateWithDuration:0.25
                          delay:0.0
         usingSpringWithDamping:100.0
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.frame = CGRectMake((frame.size.width-VIEW_WIDTH)/2, frame.size.height, VIEW_WIDTH, VIEW_HEIGHT);
                         
                     }
                     completion:^(BOOL finished){
                         completionBlock();
                     }];
}

# pragma mark - Delgate

- (void)doneButtonPressed {
    
    [self.delegate doneButtonPressed];
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker {
    
    [self.delegate dateChanged:datePicker.date];
}

@end
