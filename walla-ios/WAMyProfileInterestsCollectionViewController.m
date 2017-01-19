//
//  WAMyProfileInterestsCollectionViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileInterestsCollectionViewController.h"

#import "WAServer.h"
#import "WAValues.h"

@import Firebase;

@interface WAMyProfileInterestsCollectionViewController ()

@end

@implementation WAMyProfileInterestsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Interests";
    
    // Set up collection view
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WAInterestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"interestCell"];
    
    self.collectionView.backgroundColor = [WAValues defaultTableViewBackgroundColor];;
    
    // Initialize default values
    
    self.selectedInterestsArray = [[NSMutableArray alloc] init];
    self.interestsArray = [WAValues interestsArray];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [WAServer getUserInterestsWithID:[FIRAuth auth].currentUser.uid completion:^(NSArray *interests){
        
        if ([interests count] > 0) {
            
            [self.selectedInterestsArray removeAllObjects];
            
            for (NSString *interest in interests) {
                [self.selectedInterestsArray addObject:interest];
            }
            
            [self.collectionView reloadData];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [WAServer updateUserInterests:self.selectedInterestsArray completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.interestsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WAInterestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"interestCell" forIndexPath:indexPath];
    
    if ([self.selectedInterestsArray containsObject:[self.interestsArray objectAtIndex:indexPath.row][0]]) {
        [cell.shadowView changeFillColor:[WAValues selectedCellColor]];
    }
    else {
        [cell.shadowView changeFillColor:[UIColor whiteColor]];
    }
    
    cell.interestLabel.text = [self.interestsArray objectAtIndex:indexPath.row][0];
    
    cell.interestImageView.image = [UIImage imageNamed:[self.interestsArray objectAtIndex:indexPath.row][1]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.view.frame.size.width - 40.0)/3.0, ((self.view.frame.size.width - 40.0)/3.0)*1.1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.selectedInterestsArray containsObject:[self.interestsArray objectAtIndex:indexPath.row][0]]) {
        [self.selectedInterestsArray removeObject:[self.interestsArray objectAtIndex:indexPath.row][0]];
    }
    else {
        [self.selectedInterestsArray addObject:[self.interestsArray objectAtIndex:indexPath.row][0]];
    }
    
    [collectionView reloadData];
}

@end
