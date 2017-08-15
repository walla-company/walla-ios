//
//  WAAddLocationViewController
//  walla-ios
//
//  Created by Stas Tomych on 1/13/17.
//  Copyright © 2017 Stas Tomych. All rights reserved.
//
#define kCellIdentifier                 @"Cell"

#import "WAAddLocationViewController.h"
#import "PlaceTableViewCell.h"
@import GooglePlaces;
@import GoogleMaps;

@interface WAAddLocationViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *tableViewActivityIndicator;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) GMSPlacesClient *placesClient;
@property (nonatomic, strong) GMSMapView *map;
@property (nonatomic, strong) GMSMarker *touchMarker;
@property (nonatomic, strong) NSArray<GMSAutocompletePrediction *> *predictions;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (nonatomic, strong) GMSPlace *selectedPlace;

@end

@implementation WAAddLocationViewController

#pragma mark - Init
- (void)viewDidLoad {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.cancelBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonClicked)];
    self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
    searchTextField.textAlignment = NSTextAlignmentLeft;
    searchTextField.returnKeyType = UIReturnKeyDone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self askForPermissions];
    self.placesClient = [[GMSPlacesClient alloc] init];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)askForPermissions {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self setupMap];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)setupMap {
    CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
    if (coordinate.longitude == 0 && coordinate.latitude == 0) {
        coordinate = CLLocationCoordinate2DMake(34.052235, -118.243683);
    }
    [self setMapPosition:coordinate];
    self.map.buildingsEnabled = YES;
    self.map.indoorEnabled = YES;
    self.map.delegate = self;
    self.map.myLocationEnabled = YES;
    [self.mapView addSubview: self.map];
    self.map.settings.myLocationButton = YES;
}

- (void)setMapPosition:(CLLocationCoordinate2D)coordinate {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:16];
    self.map = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.mapView.frame.size.width, self.mapView.frame.size.height) camera:camera];
}

- (NSArray<GMSPlace *> *)placesFromPlaceLikelihoodArray:(NSArray<GMSPlaceLikelihood *> *)placeLikelihoodArray {
    NSMutableArray *result = [NSMutableArray new];
    for (GMSPlaceLikelihood *placeLikelihood in placeLikelihoodArray) {
        [result addObject:placeLikelihood.place];
    }
    return result;
}

- (NSString *)shortAddress:(NSArray <GMSAddressComponent*> *)addressComponents {
    return nil;
}

- (void)getPlacesForString:(NSString *)string position:(CLLocationCoordinate2D)position isAddress:(BOOL)isAddress {
    __weak typeof(self) weakSelf = self;
    self.tableViewActivityIndicator.hidden = NO;
    [self.tableViewActivityIndicator startAnimating];
    self.placesClient = [[GMSPlacesClient alloc] init];
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc]init];
    GMSPlacesAutocompleteTypeFilter filterType = isAddress ? kGMSPlacesAutocompleteTypeFilterAddress : kGMSPlacesAutocompleteTypeFilterEstablishment;
    [filter setType:filterType];
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(position.latitude + 0.001, position.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(position.latitude - 0.001, position.longitude - 0.001);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
    GMSPlacesClient *placesClient = [GMSPlacesClient sharedClient];
    [placesClient autocompleteQuery:string bounds:bounds filter:filter callback:^(NSArray *results, NSError *error) {
        [weakSelf.tableViewActivityIndicator stopAnimating];
        if (error != nil) {
            NSLog(@"Autocomplete error %@", [error localizedDescription]);
            return;
        } else {
            weakSelf.filteredPlaces = results;
        }
    }];
}

- (void)addMarker:(CLLocationCoordinate2D)coordinate {
    self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
    [self.map clear];
    self.touchMarker = [GMSMarker markerWithPosition:coordinate];
    self.touchMarker.map = self.map;
    self.touchMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
}

- (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate {
    __weak typeof(self) weakSelf = self;
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        if (error != nil && [response results].count > 0) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            GMSAddress* address = [response results].firstObject;
            [weakSelf getPlacesForString:address.thoroughfare position:coordinate isAddress:YES];
        }
    }];
}


#pragma mark - Actions

- (void)cancelButtonClicked {
    [self.delegate addLocationViewControllerWasCancelled:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Properties
- (void)setFilteredPlaces:(NSArray<GMSAutocompletePrediction *> *)filteredPlaces {
    _predictions = filteredPlaces;
    [self.tableView reloadData];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.predictions.count;//self.wasFilteringEnabled ? self.predictions.count : self.selectedPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    UIView *customColorView = [[UIView alloc] init];
    customColorView.backgroundColor = [UIColor darkGrayColor];
    cell.placeTitle.highlightedTextColor = [UIColor whiteColor];
    cell.selectedBackgroundView =  customColorView;
    cell.iconImageView.image = [UIImage imageNamed:@"location_image"];

    GMSAutocompletePrediction *prediction = self.predictions[indexPath.row];
    cell.placeTitle.text = prediction.attributedPrimaryText.string;
    cell.placeAddress.text = prediction.attributedSecondaryText.string;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
        GMSAutocompletePrediction *prediction = self.predictions[indexPath.row];
        [self.placesClient lookUpPlaceID:prediction.placeID callback:^(GMSPlace *place, NSError *error) {
            if (error != nil) {
                NSLog(@"Place Details error %@", [error localizedDescription]);
                return;
            } else {
                [weakSelf handlePlace:place];
            }
        }];
}

- (void)handlePlace:(GMSPlace *)place {
    [self addMarker:place.coordinate];
    self.mapViewHeightConstraint.constant = 340;
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude zoom:16];
    
    [self.map animateToCameraPosition: cameraPosition];
    self.selectedPlace = place;
    if (![self.searchBar isFirstResponder]) {
        [self.searchBar becomeFirstResponder];
    }
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return true;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        [self.tableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.selectedPlace = nil;
    NSString *searchString = [searchText lowercaseString];
    if (searchString.length > 0) {
        self.mapViewHeightConstraint.constant = 0;
        [self getPlacesForString:searchString position:[[CLLocationManager alloc] init].location.coordinate isAddress:NO];
    } else {
        self.mapViewHeightConstraint.constant = 340;
        self.predictions = [[NSArray alloc] init];
        [self.tableView reloadData];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        [self.tableView reloadData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.selectedPlace != nil) {
        [self.delegate addLocationViewController:self didAutocompleteWithPlace:self.selectedPlace];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [searchBar resignFirstResponder];
    }
}

#pragma mark - Keyboard Notifications
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat kbHeight = kbSize.height;
    self.tableViewBottomConstraint.constant = kbHeight;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.tableViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self setupMap];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            NSLog(@"User has not given access to location data");
            break;
        case kCLAuthorizationStatusNotDetermined:
            [manager requestWhenInUseAuthorization];
            break;
        default:
            break;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self addMarker:coordinate];
    [self reverseGeocodeCoordinate:coordinate];
}

- (void)mapView:(GMSMapView *)mapView didTapPOIWithPlaceID:(NSString *)placeID name:(NSString *)name location:(CLLocationCoordinate2D)location {
    [self addMarker:location];
    __weak typeof(self) weakSelf = self;
    [self.placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
        if (error == nil && place != nil) {
            [weakSelf.delegate addLocationViewController: weakSelf didAutocompleteWithPlace:place];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];

    
}
@end
