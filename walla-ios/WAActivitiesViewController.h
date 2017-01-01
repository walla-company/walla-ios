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

@interface WAActivitiesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, WAActivityTabDelegate>

@property (strong, nonatomic) IBOutlet UITableView *activitiesTableView;

@property (strong, nonatomic) IBOutlet UICollectionView *filtersCollectionView;

@property int currentFilterIndex;
@property NSArray *interestsArray;

@property NSString *openGroupID;
@property NSString *openActivityID;

@property NSArray *activitiesArray;

@end
