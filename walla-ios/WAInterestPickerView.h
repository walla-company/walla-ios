//
//  WAInterestPickerView.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/28/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAInterestCollectionViewCell.h"

typedef void(^animationCompletion)(void);

@protocol WAInterestPickerViewDelegate <NSObject>

- (void)doneButtonPressed;

- (void)interestsChanged:(NSArray *)interests;

@end

@interface WAInterestPickerView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property UILabel *titleLabel;

@property UIButton *doneButton;

@property CGRect superViewFrame;

@property UIView *primaryView;
@property UIView *secondaryView;

@property UICollectionView *interestsCollectionView;

@property NSMutableArray *selectedInterests;
@property NSInteger maxInterests;
@property NSArray *allInterests;

@property id <WAInterestPickerViewDelegate> delegate;

- (id)initWithSuperViewFrame:(CGRect)frame title:(NSString *)title selectedInterests:(NSArray *)selectedInterests maxInterests:(NSInteger)maxInterests;

- (void)animateUp:(CGRect)frame;

- (void)animateDown:(CGRect)frame completion:(animationCompletion) completionBlock;

@end
