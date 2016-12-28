//
//  WADiscoverFriendSuggestionsTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WADiscoverFriendSuggestionsTableViewCell.h"

@implementation WADiscoverFriendSuggestionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Set up collection view
    
    [self.suggestedFriendsCollectionView registerNib:[UINib nibWithNibName:@"WASuggestedUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"suggestedUserCell"];
    
    self.suggestedFriendsCollectionView.delegate = self;
    self.suggestedFriendsCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Collections view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate suggestedUserSelected:@"USERID"];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WASuggestedUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"suggestedUserCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.addFriendView.layer.cornerRadius = 6.0;
    
    return cell;
}

@end
