//
//  WAMyProfileInterestsCollectionViewController.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WAInterestCollectionViewCell.h"

@interface WAMyProfileInterestsCollectionViewController : UICollectionViewController

@property NSArray *interestsArray;

@property NSMutableArray *selectedInterestsArray;

@end
