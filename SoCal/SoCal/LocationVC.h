//
//  LocationVC.h
//  SoCal
//
//  Created by Rayser on 4/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationVC : UIViewController
{
    UISwipeGestureRecognizer *downSwipe;
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITextField *searchField;

@property (nonatomic, weak) IBOutlet UILabel *placeName;
@property (nonatomic, weak) IBOutlet UILabel *placeAddress;

@property (nonatomic, weak) IBOutlet UITableView *placesTable;

@end
