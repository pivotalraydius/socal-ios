//
//  LocationVC.m
//  SoCal
//
//  Created by Rayser on 4/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "LocationVC.h"
#import "UIBAlertView.h"
#import "PlaceSearchCell.h"
#import "ComposeVC.h"

@implementation LocationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.arFilteredPlaces = [[NSMutableArray alloc] initWithCapacity:0];
    firstTime = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self setupFonts];
    
    CGFloat lat = 1.2893;
    CGFloat lng = 103.7819;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = CLLocationCoordinate2DMake(lat, lng);
    [self.mapView setRegion:region animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI {
    
    if ([Helpers iPhone4]) {
     
        [self.placesTable setFrame:CGRectMake(self.placesTable.frame.origin.x, self.placesTable.frame.origin.y, self.placesTable.frame.size.width, self.placesTable.frame.size.height-88)];
    }
}

-(void)setupFonts {
    
    [self.lblMainTitleLabel setFont:[Helpers Exo2Regular:24.0]];
    
    [self.txtPlaceName setFont:[Helpers Exo2Regular:14.0]];
    [self.txtCityName setFont:[Helpers Exo2Regular:14.0]];
    
    [self.placeName setFont:[Helpers Exo2Regular:14.0]];
    [self.placeAddress setFont:[Helpers Exo2Regular:14.0]];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)closeButtonAction {
    
    [(ComposeVC *)self.parentVC setSelectedLocationDict:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButtonAction {
    
    [(ComposeVC *)self.parentVC setSelectedLocationDict:selectedPlaceDict];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get Location Methods

-(void)searchForPlacesOnServer {
    
    [self hideKeyboard];
    
    [[NetworkAPIClient sharedClient] cancelHTTPOperationsWithPath:PLACES_WITHIN_LOCATION];
    [[NetworkAPIClient sharedClient] cancelHTTPOperationsWithPath:PLACES_CHECKIN_SEARCH_NEARBY_PLACES];
    [[NetworkAPIClient sharedClient] cancelHTTPOperationsWithPath:PLACES_WITHIN_LOCALITY];
    
    NSString *locationKeyword = [[self.txtPlaceName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    NSString *cityKeyword = [[self.txtCityName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString] ;
    
    CLLocationCoordinate2D centerCoor = [self.mapView centerCoordinate];
    CLLocationCoordinate2D topCenterCoor = [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width / 2.0f, 0) toCoordinateFromView:self.mapView];
    
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
    CLLocation *topCenterLocation = [[CLLocation alloc] initWithLatitude:topCenterCoor.latitude longitude:topCenterCoor.longitude];
    
    CLLocationDistance radius = [centerLocation distanceFromLocation:topCenterLocation];
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSString *path = PLACES_WITHIN_LOCATION;
    
    if ([locationKeyword isEqualToString:@""] && [cityKeyword isEqualToString:@""]) {
        
        //has neither keywords
        //do a map-restricted search without keywords
        
        path = PLACES_CHECKIN_SEARCH_NEARBY_PLACES;
        radius = radius/1000; //select_venue API uses km instead of m
        
        [queryInfo setObject:[NSNumber numberWithFloat:centerCoor.latitude] forKey:@"latitude"];
        [queryInfo setObject:[NSNumber numberWithFloat:centerCoor.longitude] forKey:@"longitude"];
        [queryInfo setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
    }
    else if ([locationKeyword isEqualToString:@""] && ![cityKeyword isEqualToString:@""]) {
        
        //has city keyword no location keyword
        //alert user to input location keyword
        
        UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Missing main keyword" message:@"Please enter the main search keyword together with your city keyword." cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            
        }];
        
        return;
    }
    else if (![locationKeyword isEqualToString:@""] && [cityKeyword isEqualToString:@""]) {
        
        //has location keyword no city keyword
        //do a map-restricted search with location keyword
        
        path = PLACES_WITHIN_LOCATION;
        
        [queryInfo setObject:[NSNumber numberWithFloat:centerCoor.latitude] forKey:@"latitude"];
        [queryInfo setObject:[NSNumber numberWithFloat:centerCoor.longitude] forKey:@"longitude"];
        [queryInfo setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
        
        [queryInfo setObject:locationKeyword forKey:@"keyword"];
        
    }
    else if (![locationKeyword isEqualToString:@""] && ![cityKeyword isEqualToString:@""]) {
        
        //has both keywords
        //do a non-map-restricted locality search with both keywords
        
        path = PLACES_WITHIN_LOCALITY;
        
        [queryInfo setObject:locationKeyword forKey:@"keyword"];
        [queryInfo setObject:cityKeyword forKey:@"locality"];
    }
    
    [self.arFilteredPlaces removeAllObjects];
    [self.placesTable reloadData];
    selectedPlaceDict = nil;
    
    [[NetworkAPIClient sharedClient] POST:path parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.arFilteredPlaces removeAllObjects];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSArray *dbArray = [responseObject objectForKey:@"database"];
            NSArray *ftArray = [responseObject objectForKey:@"factual"];
            
            [self.arFilteredPlaces addObjectsFromArray:dbArray];
            [self.arFilteredPlaces addObjectsFromArray:ftArray];
        }
        else if ([responseObject isKindOfClass:[NSArray class]]) {
            
            [self.arFilteredPlaces addObjectsFromArray:responseObject];
        }
        
        [self.placesTable reloadData];
        selectedPlaceDict = nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.arFilteredPlaces removeAllObjects];
        
        [self.txtPlaceName setText:@""];
        
        [self.placesTable reloadData];
        selectedPlaceDict = nil;
    }];
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arFilteredPlaces.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    PlaceSearchCell *cell = (PlaceSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"PlaceSearchCell"];
    
    if (!cell) {
        cell = [PlaceSearchCell newCell];
    }
    
    NSDictionary *placeDict = [self.arFilteredPlaces objectAtIndex:indexPath.row];
    
    [cell.lblPlaceName setText:[placeDict objectForKey:@"name"]];
    [cell.lblPlaceAddress setText:[placeDict objectForKey:@"address"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *placeDict = [self.arFilteredPlaces objectAtIndex:indexPath.row];
    
    [self.placeName setText:[placeDict objectForKey:@"name"]];
    [self.placeAddress setText:[placeDict objectForKey:@"address"]];
    
    CGFloat lat = [[placeDict objectForKey:@"latitude"] floatValue];
    CGFloat lng = [[placeDict objectForKey:@"longitude"] floatValue];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = CLLocationCoordinate2DMake(lat, lng);
    [self.mapView setRegion:region animated:YES];
    
    selectedPlaceDict = placeDict;
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.txtPlaceName || self.txtCityName) {
        
        [self searchForPlacesOnServer];
    }
    
    return YES;
}

#pragma mark - MapView Delegate Methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CGFloat lat = userLocation.location.coordinate.latitude;
    CGFloat lng = userLocation.location.coordinate.longitude;
    
    if (lat != 0.00 && lng != 0.00 && !firstTime) {
     
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = CLLocationCoordinate2DMake(lat, lng);
        [self.mapView setRegion:region animated:YES];
        
        firstTime = YES;
    }
}

#pragma mark - Keyboard Methods

-(void)keyboardWillShow {
    
    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downSwipe];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)keyboardWillHide {
    
    [self.view removeGestureRecognizer:downSwipe];
    [self.view removeGestureRecognizer:tapGesture];
}

-(void)hideKeyboard {
    
    [self.txtPlaceName resignFirstResponder];
    [self.txtCityName resignFirstResponder];
}

@end
