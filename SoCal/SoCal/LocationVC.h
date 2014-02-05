//
//  LocationVC.h
//  SoCal
//
//  Created by Rayser on 4/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    UISwipeGestureRecognizer *downSwipe;
    UITapGestureRecognizer *tapGesture;
    
    NSDictionary *selectedPlaceDict;
}

@property (nonatomic, weak) id parentVC;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITextField *txtPlaceName;
@property (nonatomic, weak) IBOutlet UITextField *txtCityName;

@property (nonatomic, weak) IBOutlet UILabel *placeName;
@property (nonatomic, weak) IBOutlet UILabel *placeAddress;

@property (nonatomic, weak) IBOutlet UITableView *placesTable;
@property (nonatomic, strong) NSMutableArray *arFilteredPlaces;

@end
