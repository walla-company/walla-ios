//
//  WAAddLocationViewController
//  walla-ios
//
//  Created by Stas Tomych on 1/13/17.
//  Copyright © 2017 Stas Tomych. All rights reserved.
//


#import <UIKit/UIKit.h>
@import CoreLocation;
@import GooglePlaces;
@import GoogleMaps;

@protocol WAAddLocationViewControllerDelegate;

@interface WAAddLocationViewController : UIViewController

@property (nonatomic, weak)id<WAAddLocationViewControllerDelegate>delegate;

@end

@protocol WAAddLocationViewControllerDelegate <NSObject>

- (void)addLocationViewController: (WAAddLocationViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place;

- (void)addLocationViewController:(WAAddLocationViewController *)viewController didFailAutocompleteWithError:(NSError *)error;

- (void)addLocationViewControllerWasCancelled:(WAAddLocationViewController *)viewController;




@end
