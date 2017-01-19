//
//  WADiscoverFriendSuggestionsTableViewCell.h
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WASuggestedUserCollectionViewCell.h"

@protocol WADiscoverFriendSuggestionsTableViewCellDelegate <NSObject>

- (void)suggestedUserSelected:(NSString *)userID;

@end

@interface WADiscoverFriendSuggestionsTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property id <WADiscoverFriendSuggestionsTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UICollectionView *suggestedFriendsCollectionView;

@property NSArray *suggestedUsers;

@property NSMutableDictionary *profileImagesDictionary;

@end
