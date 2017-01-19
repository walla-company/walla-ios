//
//  WADiscoverFriendSuggestionsTableViewCell.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WADiscoverFriendSuggestionsTableViewCell.h"

#import "WAServer.h"
#import "WAUser.h"

@import Firebase;

@implementation WADiscoverFriendSuggestionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Set up collection view
    
    [self.suggestedFriendsCollectionView registerNib:[UINib nibWithNibName:@"WASuggestedUserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"suggestedUserCell"];
    
    self.suggestedFriendsCollectionView.delegate = self;
    self.suggestedFriendsCollectionView.dataSource = self;
    
    // Load suggested users
    
    [WAServer getSuggestedUsers:^(NSArray *users) {
        self.suggestedUsers = users;
        [self.suggestedFriendsCollectionView reloadData];
    }];
    
    // Initialize default values
    
    self.profileImagesDictionary = [[NSMutableDictionary alloc] init];
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
    
    return [self.suggestedUsers count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WAUser *user = [self.suggestedUsers objectAtIndex:indexPath.row];
    
    [self.delegate suggestedUserSelected:user.userID];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WASuggestedUserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"suggestedUserCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.addFriendView.layer.cornerRadius = 6.0;
    
    WAUser *user = [self.suggestedUsers objectAtIndex:indexPath.row];
    
    cell.nameInfoLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    UIImage *profileImage = [self.profileImagesDictionary objectForKey:user.userID];
    
    cell.profileImageView.clipsToBounds = true;
    cell.profileImageView.layer.cornerRadius = 32.5;
    
    if (profileImage) {
        cell.profileImageView.image = profileImage;
    }
    else {
        [self.profileImagesDictionary setObject:[UIImage imageNamed:@"BlankCircle"] forKey:user.userID];
        [self loadProfileImage:user.profileImageURL forUserID:user.userID];
    }
    
    return cell;
}

- (void)loadProfileImage:(NSString *)profileImageURL forUserID:(NSString *)userID {
    
    if (![profileImageURL isEqualToString:@""]) {
        
        FIRStorage *storage = [FIRStorage storage];
        
        FIRStorageReference *imageRef = [storage referenceForURL:profileImageURL];
        
        [imageRef dataWithMaxSize:10 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
            if (error != nil) {
                
                NSLog(@"Error downloading profile image: %@", error);
                
            } else {
                
                [self.profileImagesDictionary setObject:[UIImage imageWithData:data] forKey:userID];
                [self.suggestedFriendsCollectionView reloadData];
            }
        }];
    }
}

@end
