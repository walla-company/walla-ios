//
//  WAMyProfileInterestsCollectionViewController.m
//  walla-ios
//
//  Created by Joseph DeChicchis on 12/27/16.
//  Copyright © 2016 GenieUS, Inc. All rights reserved.
//

#import "WAMyProfileInterestsCollectionViewController.h"

#import "WAValues.h"

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
    
    if ([self.selectedInterestsArray containsObject:self.interestsArray[indexPath.row][0]]) {
        [cell.shadowView changeFillColor:[WAValues selectedCellColor]];
    }
    else {
        [cell.shadowView changeFillColor:[UIColor whiteColor]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.view.frame.size.width - 40.0)/3.0, ((self.view.frame.size.width - 40.0)/3.0)*1.1);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.selectedInterestsArray containsObject:self.interestsArray[indexPath.row][0]]) {
        [self.selectedInterestsArray removeObject:self.interestsArray[indexPath.row][0]];
    }
    else {
        [self.selectedInterestsArray addObject:self.interestsArray[indexPath.row][0]];
    }
    
    [collectionView reloadData];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
