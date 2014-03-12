//
//  ComposeVC.h
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "RDLabeledTextView.h"
#import <MapKit/MapKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface ComposeVC : UIViewController <CKCalendarDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate, MKMapViewDelegate, RDLabeledTextViewDelegate>
{
    NSInteger currentlySelectedDateTimeCell;
    
    UISwipeGestureRecognizer *downSwipe;
    UITapGestureRecognizer *tapGesture;
    
    BOOL locationPickerShown;
    
    BOOL firstTime;
    
    UIView *bigMama;
}

@property (nonatomic, weak) id parentVC;

@property (nonatomic, weak) IBOutlet UITableView *contactsTableview;
@property (nonatomic, weak) IBOutlet UIView *contactsSelectionContainer;
@property (nonatomic, weak) IBOutlet UIButton *contactDoneButton;
@property (nonatomic, strong) NSMutableArray *selectedContacts;

@property (nonatomic, strong) MFMailComposeViewController *mailComposeVC;
@property (nonatomic, strong) ABPeoplePickerNavigationController *contactsPicker;
@property (nonatomic, weak) IBOutlet CKCalendarView *calendarView;
@property (nonatomic, strong) NSMutableDictionary *selectedCalendarDatesDict;
@property (nonatomic, strong) NSMutableArray *viewsForSelectedCalendarDates;

@property (nonatomic, weak) IBOutlet UITableView *dateTimeTable;
@property (nonatomic, strong) NSMutableArray *eventDateTimesArray;
@property (nonatomic, strong) NSMutableArray *contactsWithEmail;

@property (nonatomic, weak) IBOutlet UILabel *mainTitleLabel;

@property (nonatomic, weak) IBOutlet UIButton *dateTimeDoneButton;

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;

@property (nonatomic, weak) IBOutlet UIView *timePickerView;
@property (nonatomic, weak) IBOutlet UIDatePicker *timePicker;

@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, weak) IBOutlet UIView *composeEventContainer;
@property (nonatomic, weak) IBOutlet UIView *timeSelectionContainer;

@property (nonatomic, weak) IBOutlet UITextField *txtEventName;
@property (nonatomic, weak) IBOutlet RDLabeledTextView *txtDescription;
@property (nonatomic, weak) IBOutlet UIButton *btnTxtDescriptionClearButton;

@property (nonatomic, weak) IBOutlet UIControl *btnLocation;
@property (nonatomic, weak) IBOutlet UILabel *lblBtnLocation;
@property (nonatomic, weak) IBOutlet UIButton *selectDatesButton;
@property (nonatomic, weak) IBOutlet UIButton *selectContactsButton;

@property (nonatomic, strong) NSDictionary *selectedLocationDict;

@property (nonatomic, strong) NSNumber *invitationCode;

@property (nonatomic, weak) IBOutlet UIView *locationPickerContainer;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UITextField *txtPlaceName;
@property (nonatomic, weak) IBOutlet UITextField *txtCityName;
@property (nonatomic, weak) IBOutlet UITableView *placesTable;
@property (nonatomic, strong) NSMutableArray *arFilteredPlaces;

-(void)deleteCellAtIndexPathRow:(NSInteger)row;
-(void)editTimeForCellAtIndexPathRow:(NSInteger)row;
-(void)closeTimePanelForCellAtIndexPathRow:(NSInteger)row;

@end
