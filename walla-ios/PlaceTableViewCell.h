//
//  PlaceTableViewCell.h
//  RetailScanningApp
//
//  Created by Stas Tomych on 1/14/17.
//  Copyright © 2017 Stas Tomych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *placeTitle;

@property (weak, nonatomic) IBOutlet UILabel *placeAddress;

@end
