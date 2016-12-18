//
//  WAActivitiesViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/15/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAActivityTableViewCell.h"

#import "WAFilterCollectionViewCell.h"

@interface WAActivitiesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *activitiesTableView;

@property (strong, nonatomic) IBOutlet UICollectionView *filtersCollectionView;

@property int currentFilterIndex;

@property UIColor *tabColorLightGray;
@property UIColor *tabColorOrange;
@property UIColor *tabColorOffwhite;

@end
