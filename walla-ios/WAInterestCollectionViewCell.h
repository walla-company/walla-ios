//
//  WAInterestCollectionViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAShadowView.h"

@interface WAInterestCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet WAShadowView *shadowView;

@property (strong, nonatomic) IBOutlet UILabel *interestLabel;

@property (strong, nonatomic) IBOutlet UIImageView *interestImageView;

@end
