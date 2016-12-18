//
//  WAFilterCollectionViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAFilterCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIView *circleView;

@property (strong, nonatomic) IBOutlet UIImageView *filterImageView;

@property (strong, nonatomic) IBOutlet UILabel *filterLabel;

@end
