//
//  WASuggestedUserCollectionViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WASuggestedUserCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameInfoLabel;

@property (strong, nonatomic) IBOutlet UIView *addFriendView;
@property (strong, nonatomic) IBOutlet UIButton *addFriendButton;

@end
