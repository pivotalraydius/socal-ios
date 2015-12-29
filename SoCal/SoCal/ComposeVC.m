//
//  ComposeVC.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "ComposeVC.h"
#import "ComposeDateTimeCell.h"
#import "ContactCell.h"
#import "RDPieView.h"
#import "UIBAlertView.h"
#import "UIImage+MDQRCode.h"
#import "PlaceSearchCell.h"
#import "MainVC.h"
#import <MessageUI/MessageUI.h>

@implementation ComposeVC

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

-(void)initialize {
    
    self.arFilteredPlaces = [[NSMutableArray alloc] initWithCapacity:0];
    firstTime = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTestData];
    [self setupMainScrollView];
    [self setupUI];
    [self setupFonts];
    [self addLocationVCView];
    [self getNewInviteCode];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.selectedLocationDict) {
        [self.lblBtnLocation setText:[self.selectedLocationDict objectForKey:@"name"]];
    }
    else {
        [self.lblBtnLocation setText:@"Location"];
    }
    
    if(self.contactsWithEmail.count<=0) [self checkAddressBookAccess];
    
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setupUI {
    
    if ([Helpers iPhone4]) {
        
        [self.mainScrollView setFrame:CGRectMake(self.mainScrollView.frame.origin.x, self.mainScrollView.frame.origin.y, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height-88)];
        [self.composeEventContainer setFrame:CGRectMake(self.composeEventContainer.frame.origin.x, self.composeEventContainer.frame.origin.y, self.composeEventContainer.frame.size.width, self.composeEventContainer.frame.size.height-88)];
        [self.dateTimeTable setFrame:CGRectMake(self.dateTimeTable.frame.origin.x, self.dateTimeTable.frame.origin.y-40, self.dateTimeTable.frame.size.width, self.dateTimeTable.frame.size.height-48)];
        [self.selectDatesButton setFrame:CGRectMake(self.selectDatesButton.frame.origin.x, self.selectDatesButton.frame.origin.y-88, self.selectDatesButton.frame.size.width, self.selectDatesButton.frame.size.height)];
        [self.selectContactsButton setFrame:CGRectMake(self.selectContactsButton.frame.origin.x, self.selectContactsButton.frame.origin.y-88, self.selectContactsButton.frame.size.width, self.selectContactsButton.frame.size.height)];
        [self.dateTimeDoneButton setFrame:CGRectMake(self.dateTimeDoneButton.frame.origin.x, self.dateTimeDoneButton.frame.origin.y-88, self.dateTimeDoneButton.frame.size.width, self.dateTimeDoneButton.frame.size.height)];
        [self.contactsTableview setFrame:CGRectMake(self.contactsTableview.frame.origin.x, self.contactsTableview.frame.origin.y, self.contactsTableview.frame.size.width, self.contactsTableview.frame.size.height-88)];
        [self.contactDoneButton setFrame:CGRectMake(self.contactDoneButton.frame.origin.x, self.contactDoneButton.frame.origin.y-88, self.contactDoneButton.frame.size.width, self.contactDoneButton.frame.size.height)];
    }

    [self.txtDescription setDelegate:self];
    
    [Helpers setBorderToView:self.btnTxtDescriptionClearButton borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:self.btnTxtDescriptionClearButton.frame.size.height/2];
    
    [self.txtEventName setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
    [self.btnLocation setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
    [self.txtDescription setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
}

-(void)setupFonts {
    
    [self.mainTitleLabel setFont:[Helpers Exo2Regular:24.0]];
    
    [self.dateTimeDoneButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    [self.closeButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    [self.doneButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    
    [self.txtEventName setFont:[Helpers Exo2Regular:18.0]];
    
    [self.txtDescription setTextFont:[Helpers Exo2Regular:14.0]];
    [self.txtDescription setTitleFont:[Helpers Exo2Regular:18.0]];
    
    [self.lblBtnLocation setFont:[Helpers Exo2Regular:18.0]];
    
    [self.selectDatesButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    [self.selectContactsButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    
    [self.contactDoneButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    
    [self.txtPlaceName setFont:[Helpers Exo2Regular:18.0]];
    [self.txtCityName setFont:[Helpers Exo2Regular:14.0]];
    
//    UILabel *label = [UILabel appearanceWhenContainedIn:[UITableView class], [UIDatePicker class], nil];
//    label.font = [Helpers Exo2Regular:18.0];
}

-(void)setupTestData {
    
    self.contactsWithEmail = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedContacts = [[NSMutableArray alloc] initWithCapacity:0];
    self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedCalendarDatesDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.viewsForSelectedCalendarDates = [[NSMutableArray alloc] initWithCapacity:0];
    
//    [self checkAddressBookAccess];
    
    currentlySelectedDateTimeCell = -1;
}

-(void)setupMainScrollView {
    
    [self.mainScrollView addSubview:self.composeEventContainer];
    
    [self.composeEventContainer setFrame:CGRectMake(0, 0, self.composeEventContainer.frame.size.width, self.composeEventContainer.frame.size.height)];
    
    [self setupComposeEventContainer];
    
    [self.mainScrollView addSubview:self.timeSelectionContainer];
    [self.mainScrollView addSubview:self.contactsSelectionContainer];
    
    [self.timeSelectionContainer setFrame:CGRectMake(320, 0, self.timeSelectionContainer.frame.size.width, self.timeSelectionContainer.frame.size.height)];
    [self.contactsSelectionContainer setFrame:CGRectMake(640, 0, self.contactsSelectionContainer.frame.size.width, self.contactsSelectionContainer.frame.size.height)];
    
    [self setupTimeSelectionContainer];
    
    [self.mainScrollView setContentSize:CGSizeMake(960.0, self.mainScrollView.frame.size.height)];
}

-(void)setupComposeEventContainer {
    
    [self.txtEventName setValue:[Helpers bondiBlueColorWithAlpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.txtDescription setTitle:@"Description"];
    
    [self.txtDescription setTitleColor:[Helpers bondiBlueColorWithAlpha:1.0]];
    [self.txtDescription setTextColor:[Helpers bondiBlueColorWithAlpha:1.0]];
    
    [Helpers setBorderToView:self.txtEventName borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
    [Helpers setBorderToView:self.btnLocation borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
    [Helpers setBorderToView:self.txtDescription borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
}

-(void)setupTimeSelectionContainer {
 
    [self setupCalendar];
    [self setupTimePicker];
}

-(void)setupCalendar {
    
    [self.calendarView setOnlyShowCurrentMonth:NO];
    
    [self.calendarView setBackgroundColor:[UIColor clearColor]];
    [self.calendarView setInnerBorderColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    [self.calendarView setDayOfWeekTextColor:[UIColor whiteColor]];
    [self.calendarView setDateFont:[Helpers Exo2Regular:11.0]];
    [self.calendarView setTitleFont:[Helpers Exo2Medium:16.0]];
    [self.calendarView setTitleColor:[UIColor whiteColor]];
    
    [self.calendarView setDelegate:self];
}

-(void)scrollToTimeSelection {
    
    [self.mainScrollView setContentOffset:CGPointMake(320.0, 0.0) animated:YES];
    if(self.contactsWithEmail.count<=0) [self checkAddressBookAccess];
}

-(void)scrollToContactsSelection {
    
    [self.mainScrollView setContentOffset:CGPointMake(640.0, 0.0) animated:YES];
}

-(void)scrollToComposeEvent {
    
    [self.mainScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.dateTimeTable setHidden:NO];
}

#pragma mark - Main Actions

-(IBAction)closeButtonAction {
    
//    [self.navigationController popViewControllerAnimated:YES];
    [(MainVC *)self.parentVC closeSecondView:self.view];
}

-(IBAction)dateSelectionDoneButtonAction {
    
//    [self scrollToComposeEvent];
    [self scrollToContactsSelection];

}

-(IBAction)contactSelectionDoneButtonAction {
    
//    [self scrollToComposeEvent];
    [self createEvent];
}

-(IBAction)doneButtonAction {
    
    [self createEvent];
}

-(IBAction)selectDatesAction {
    
    [self.timeSelectionContainer setHidden:NO];
    [self scrollToTimeSelection];
}

-(IBAction)selectContactsAction {

    [self.dateTimeTable setHidden:YES];
    [self scrollToContactsSelection];
    [self.contactsTableview reloadData];
    
    for (int i = 0 ; i < self.contactsWithEmail.count ; i++) {
        
        NSDictionary *data = [self.contactsWithEmail objectAtIndex:i];
        
        if ([[data objectForKey:@"selected"] boolValue]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.contactsTableview selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
            
        }
    }
    
    NSLog(@"Done");
}

-(IBAction)locationButtonAction {
    
//    LocationVC *locationVC = [[LocationVC alloc] init];
//    [locationVC setParentVC:self];
//    [self.navigationController pushViewController:locationVC animated:YES];
    
    if (locationPickerShown) {
        [self hideLocationPicker];
    }
    else {
        [self showLocationPicker];
    }
}

#pragma mark - Location Picker Methods

-(void)showLocationPicker {
    
    [UIView animateWithDuration:0.25 animations:^{
    
        [self.btnLocation setFrame:CGRectMake(self.btnLocation.frame.origin.x, self.btnLocation.frame.origin.y, self.btnLocation.frame.size.width, 330)];
        [self.txtDescription setFrame:CGRectMake(self.txtDescription.frame.origin.x, self.btnLocation.frame.origin.y+self.btnLocation.frame.size.height+13, self.txtDescription.frame.size.width, self.txtDescription.frame.size.height)];
        [self.selectDatesButton setFrame:CGRectMake(self.selectDatesButton.frame.origin.x, self.selectDatesButton.frame.origin.y+286, self.selectDatesButton.frame.size.width, self.selectDatesButton.frame.size.height)];
        [self.selectContactsButton setFrame:CGRectMake(self.selectContactsButton.frame.origin.x, self.selectContactsButton.frame.origin.y+286, self.selectContactsButton.frame.size.width, self.selectContactsButton.frame.size.height)];
        [self.dateTimeTable setFrame:CGRectMake(self.dateTimeTable.frame.origin.x, self.dateTimeTable.frame.origin.y+286, self.dateTimeTable.frame.size.width, self.dateTimeTable.frame.size.height)];
        
        //DO TRANSITION CUSTOMIZATION FOR IPHONE4
        
    } completion:^(BOOL finished) {
        
        [self.selectDatesButton setHidden:YES];
        [self.lblBtnLocation setHidden:YES];
        [self.txtPlaceName setHidden:NO];
        locationPickerShown = YES;
        
        [self.txtPlaceName becomeFirstResponder];
    }];
    
}

-(void)hideLocationPicker {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.btnLocation setFrame:CGRectMake(self.btnLocation.frame.origin.x, self.btnLocation.frame.origin.y, self.btnLocation.frame.size.width, 44)];
        [self.txtDescription setFrame:CGRectMake(self.txtDescription.frame.origin.x, 124, self.txtDescription.frame.size.width, self.txtDescription.frame.size.height)];
        [self.selectDatesButton setFrame:CGRectMake(self.selectDatesButton.frame.origin.x, 432, self.selectDatesButton.frame.size.width, self.selectDatesButton.frame.size.height)];
        [self.selectContactsButton setFrame:CGRectMake(self.selectContactsButton.frame.origin.x, 466, self.selectContactsButton.frame.size.width, self.selectContactsButton.frame.size.height)];
        [self.dateTimeTable setFrame:CGRectMake(self.dateTimeTable.frame.origin.x, 338, self.dateTimeTable.frame.size.width, self.dateTimeTable.frame.size.height)];
        
        //DO TRANSITION CUSTOMIZATION FOR IPHONE4
        
    } completion:^(BOOL finished) {
        
        [self.selectDatesButton setHidden:NO];
        [self.lblBtnLocation setHidden:NO];
        [self.txtPlaceName setHidden:YES];
        locationPickerShown = NO;
    }];
}

-(void)addLocationVCView {
    
    [self.btnLocation addSubview:self.locationPickerContainer];
    [self.locationPickerContainer setFrame:CGRectMake(0, 44, self.btnLocation.frame.size.width, 286)];
    
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

#pragma mark - Time Picker Methods

-(void)setupTimePicker {
    
    [self.timePickerView addSubview:self.timePicker];
    [self.view addSubview:self.timePickerView];
    [self.timePickerView setFrame:CGRectMake(0, self.view.frame.size.height, self.timePickerView.frame.size.width, self.timePicker.frame.size.height)];
}

-(void)showTimePicker {
    
    NSDate *date = [self.eventDateTimesArray objectAtIndex:currentlySelectedDateTimeCell];
    
    [self.timePicker setDate:date];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.timePickerView setFrame:CGRectMake(0, self.view.frame.size.height - self.timePickerView.frame.size.height, self.timePickerView.frame.size.width, self.timePickerView.frame.size.height)];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.timePicker addTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
//    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimePicker)];
//    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
//    [self.view addGestureRecognizer:downSwipe];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimePicker)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)hideTimePicker {
    
//    [self.view removeGestureRecognizer:downSwipe];
//    downSwipe = nil;
    [self.view removeGestureRecognizer:tapGesture];
    tapGesture = nil;
    
    [self.timePicker removeTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.timePickerView setFrame:CGRectMake(0, self.view.frame.size.height, self.timePickerView.frame.size.width, self.timePickerView.frame.size.height)];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)timePickerValueChanged {
    
    ComposeDateTimeCell *cell = (ComposeDateTimeCell *)[self.dateTimeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentlySelectedDateTimeCell inSection:0]];
    
    [cell updateCellWithTime:self.timePicker.date];
    [self.dateTimeTable beginUpdates];
    [self.dateTimeTable endUpdates];
    
    [self.eventDateTimesArray removeObjectAtIndex:currentlySelectedDateTimeCell];
    [self.eventDateTimesArray insertObject:self.timePicker.date atIndex:currentlySelectedDateTimeCell];
}

#pragma mark - Calendar Delegate Methods

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    if (self.eventDateTimesArray.count < 5) {
        
        //cannot select date before current date
        if (![Helpers dateIsTodayOrLater:date]) {
         
            UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Oops!" message:@"I don't think a time machine exists yet. Please select a date and time in the future." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            }];
            
            return;
        }
        
        for (int i = 0 ; i < self.selectedCalendarDatesDict.allKeys.count ; i++) {
            
            NSString *strDateKey = [[self.selectedCalendarDatesDict allKeys] objectAtIndex:i];
            NSDate *dateKey = [Helpers dateFromString:strDateKey];
            if ([self.calendarView date:date isSameDayAsDate:dateKey]) {
                NSMutableArray *selectedDatesInADay = [self.selectedCalendarDatesDict objectForKey:strDateKey];
                if (selectedDatesInADay.count == 4) {
                    return;
                }
            }
        }
        
        if (currentlySelectedDateTimeCell >= 0) {
            
            //if selected date different from currentlyselecteddatetimecell date
            NSDate *currentlySelected = [self.eventDateTimesArray objectAtIndex:currentlySelectedDateTimeCell];
            
            NSLog(@"was selected: %@", currentlySelected);
            NSLog(@"just selected: %@", date);
            
            [self deleteCellAtIndexPathRow:currentlySelectedDateTimeCell];
            
            if ([self.calendarView date:date isSameDayAsDate:currentlySelected]) {
                
                //if same
            }
            else {
                
                //if different
                
                [self.eventDateTimesArray addObject:date];
                [self.dateTimeTable reloadData];
                
                if (self.eventDateTimesArray.count > 0) {
                    [self tableView:self.dateTimeTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.eventDateTimesArray.count-1 inSection:0]];
                }
            }
        }
        else {
            
            [self.eventDateTimesArray addObject:date];
            [self.dateTimeTable reloadData];
            
            if (self.eventDateTimesArray.count > 0) {
                [self tableView:self.dateTimeTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.eventDateTimesArray.count-1 inSection:0]];
            }
        }
    }
}

-(void)calendar:(CKCalendarView *)calendar didDeselectDate:(NSDate *)date {

}

-(void)calendar:(CKCalendarView *)calendar didLongPressDate:(NSDate *)date withGesture:(UILongPressGestureRecognizer *)gesture {
    
    BOOL valid = NO;
    
    for (int i = 0 ; i < self.selectedCalendarDatesDict.allKeys.count ; i++) {
        
        NSString *strDateKey = [[self.selectedCalendarDatesDict allKeys] objectAtIndex:i];
        NSDate *dateKey = [Helpers dateFromString:strDateKey];
        if ([self.calendarView date:date isSameDayAsDate:dateKey]) {
            NSMutableArray *selectedDatesInADay = [self.selectedCalendarDatesDict objectForKey:strDateKey];
            if (selectedDatesInADay.count > 1) {
                return;
            }
            else {
                valid = YES;
            }
        }
    }
    
    if (!valid) {
        return;
    }
    
    CGPoint touchLocation;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"began!");
        
        NSLog(@"long pressed a valid selected date. move on to step 2");
        touchLocation = [gesture locationInView:self.view];
        
        bigMama = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        
        NSDate *previous = date;
        
        for (NSDate *aDate in self.eventDateTimesArray) {
            if ([self.calendarView date:aDate isSameDayAsDate:date]) {
                previous = aDate;
            }
        }
        
        if ([Helpers isDay:previous]) {
            [bigMama setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
        }
        else {
            [bigMama setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
        }
        
        [bigMama setAlpha:0.75];
        [bigMama setFrame:CGRectMake(touchLocation.x-75, touchLocation.y-75, bigMama.frame.size.width, bigMama.frame.size.height)];
        [bigMama.layer setCornerRadius:75];
        [self.view addSubview:bigMama];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"changing!");
        
        touchLocation = [gesture locationInView:self.view];
        
        [bigMama setFrame:CGRectMake(touchLocation.x-75, touchLocation.y-75, bigMama.frame.size.width, bigMama.frame.size.height)];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ended!");
        
        [bigMama removeFromSuperview];
        bigMama = nil;
        
        BOOL withinCal = NO;
        
        touchLocation = [gesture locationInView:self.calendarView];
        if (CGRectContainsPoint(self.calendarView.frame, touchLocation)) {
            withinCal = YES;
        }
        
        NSDate *previous = date;
        NSInteger row = -1;
        
        for (NSDate *aDate in self.eventDateTimesArray) {
            if ([self.calendarView date:aDate isSameDayAsDate:date]) {
                previous = aDate;
                row = [self.eventDateTimesArray indexOfObject:aDate];
            }
        }
        
        if (!withinCal) {
         
            NSLog(@"outside calendar");
            
            //removing!
            if (row >= 0) {
                [self deleteCellAtIndexPathRow:row];
            }
            
            CGPoint datePoint = [gesture locationInView:self.calendarView];
            NSDate *new = [self.calendarView dateForLocationInView:datePoint];
            NSLog(@"date: %@", new);
            
            NSLog(@"frame: %f, %f, %f, %f", self.calendarView.frame.origin.x, self.calendarView.frame.origin.y, self.calendarView.frame.size.width, self.calendarView.frame.size.height);
            NSLog(@"point: %f, %f", datePoint.x, datePoint.y);
            
            return;
        }
        
        NSLog(@"within calendar");
        
        //moving it to new!
        
        CGPoint datePoint = [gesture locationInView:self.calendarView];
        
        NSDate *new = [self.calendarView dateForLocationInView:datePoint];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *components1 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:previous];
        NSInteger hour = [components1 hour];
        NSInteger minutes = [components1 minute];
        
        NSDateComponents *components2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:new];
        [components2 setHour:hour];
        [components2 setMinute:minutes];
        
        NSDate *newSelection = [calendar dateFromComponents:components2];
        
        //check date point, reject past dates
        
        if ([newSelection compare:[NSDate date]] == NSOrderedAscending) {
            
            //new date is past already, reject
            NSLog(@"date is in the past");
        }
        else {
            
            //removing previous
            if (row >= 0) {
                [self deleteCellAtIndexPathRow:row];
            }
            
            [self.eventDateTimesArray addObject:newSelection];
            [self.dateTimeTable reloadData];
            [self updateCalendarSubviews];
        }
    }
}

#pragma mark - Table View Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.contactsTableview) {
        return self.contactsWithEmail.count;
    }
    else if (tableView == self.placesTable) {
        return self.arFilteredPlaces.count;
    }
    else {
        return self.eventDateTimesArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (tableView == self.contactsTableview) {
     
        NSString *REUSE_ID = @"ContactCell";
        
        ContactCell *cell = nil;
        if (!(cell = (ContactCell *)[self.contactsTableview dequeueReusableCellWithIdentifier:REUSE_ID])) {
            cell = [ContactCell newContactCell];
            
//            [cell setParentVC:self];
        }
        
        NSDictionary *data = [self.contactsWithEmail objectAtIndex:indexPath.row];
        [cell renderCellWithData:data];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if (tableView == self.placesTable) {
        
        PlaceSearchCell *cell = (PlaceSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"PlaceSearchCell"];
        
        if (!cell) {
            cell = [PlaceSearchCell newCell];
        }
        
        NSDictionary *placeDict = [self.arFilteredPlaces objectAtIndex:indexPath.row];
        
        [cell.lblPlaceName setText:[placeDict objectForKey:@"name"]];
        if (![placeDict objectForKey:@"address"] || [placeDict objectForKey:@"address"] != [NSNull null]) {
            [cell.lblPlaceAddress setText:[placeDict objectForKey:@"address"]];
        }
        else {
            [cell.lblPlaceAddress setText:@""];
        }
        
        
        return cell;
    }
    else {
        ComposeDateTimeCell *cell = (ComposeDateTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"ComposeDateTimeCell"];
        
        if (!cell) {
            cell = [ComposeDateTimeCell newComposeDateTimeCell];
            [cell setParentVC:self];
        }
        
        [cell renderCellDataWithDate:[self.eventDateTimesArray objectAtIndex:indexPath.row] andIndexPathRow:indexPath.row];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.contactsTableview) {
        
        return 44.0;
    }
    else if (tableView == self.placesTable) {
        return 50.0;
    }
    else {
    
        if (indexPath.row == currentlySelectedDateTimeCell) {
            
            return 80.0;
        }
        
        return 30.0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.contactsTableview) {
        
        [[self.contactsWithEmail objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:YES] forKey:@"selected"];
    }
    else if (tableView == self.placesTable) {
        
        NSDictionary *placeDict = [self.arFilteredPlaces objectAtIndex:indexPath.row];
        
        [self.lblBtnLocation setText:[placeDict objectForKey:@"name"]];
        [self.txtPlaceName setText:[placeDict objectForKey:@"name"]];
        
        CGFloat lat = [[placeDict objectForKey:@"latitude"] floatValue];
        CGFloat lng = [[placeDict objectForKey:@"longitude"] floatValue];
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = CLLocationCoordinate2DMake(lat, lng);
        [self.mapView setRegion:region animated:YES];
        
        self.selectedLocationDict = placeDict;
    }
    else {
    
        if (indexPath.row == currentlySelectedDateTimeCell) {
            
            //already selected, deselect
            [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
        }
        
        currentlySelectedDateTimeCell = indexPath.row;
        
        [tableView beginUpdates];
        [tableView endUpdates];
        
        [self.dateTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.eventDateTimesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.contactsTableview) {
        
        [[self.contactsWithEmail objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:NO] forKey:@"selected"];
    }
    else if (tableView == self.placesTable) {
        //do nothing
    }
    else {
        
        currentlySelectedDateTimeCell = -1;
        
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainScrollView) {
        
        [(MainVC *)self.parentVC scrollBGViewToOffset:CGPointMake(scrollView.contentOffset.x+320, 0)];
        
        if (scrollView.contentOffset.x == 0.0) {
            [[(MainVC *)self.parentVC mainScrollView] setScrollEnabled:YES];
        }
        else {
            [[(MainVC *)self.parentVC mainScrollView] setScrollEnabled:NO];
        }
        
        if (scrollView.contentOffset.x >= 320.0) {
            
            [self.closeButton setHidden:YES];
            [self.doneButton setHidden:YES];
        }
        else {
            [self.closeButton setHidden:NO];
            [self.doneButton setHidden:NO];
        }
        
        if (scrollView.contentOffset.x >= 640.0) {
            [self.dateTimeTable setHidden:YES];
        }
        else {
            [self.dateTimeTable setHidden:NO];
        }
        
        [self hideKeyboard];
    }
}

#pragma mark - ComposeDateTimeCell Actions

-(void)deleteCellAtIndexPathRow:(NSInteger)row {
 
    [self.eventDateTimesArray removeObjectAtIndex:row];
    [self.dateTimeTable reloadData];
    
    currentlySelectedDateTimeCell = -1;
    
    [self updateCalendarSubviews];
}

-(void)editTimeForCellAtIndexPathRow:(NSInteger)row {
    
    if (row == currentlySelectedDateTimeCell)
        [self showTimePicker];
}

-(void)closeTimePanelForCellAtIndexPathRow:(NSInteger)row {
    
    //check if date-time combination exists
    NSDate *aDate = [self.eventDateTimesArray objectAtIndex:row];
    
    for (NSDate *date in self.eventDateTimesArray) {
        
        if (date != aDate) {
            
            if ([date compare:aDate] == NSOrderedSame) {
                
                //Duplicate!
                
                NSLog(@"Duplicate date time combi, cannot accept");
                
                UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Date-Time Already Exists" message:@"The selected date-time already exists, please choose another date-time combination." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
                }];
                
                return;
            }
        }
    }
    
    [self updateCalendarSubviews];
    
    [self tableView:self.dateTimeTable didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

-(void)updateCalendarSubviews {
    
    [self.selectedCalendarDatesDict removeAllObjects];
    [self.viewsForSelectedCalendarDates removeAllObjects];
    NSMutableArray *selectedCalendarDates = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDate *eventDateTime in self.eventDateTimesArray) {
        
        BOOL aldyExist = NO;
        
        for (int i = 0 ; i < self.selectedCalendarDatesDict.allKeys.count ; i++) {
            
            NSString *strDateKey = [[self.selectedCalendarDatesDict allKeys] objectAtIndex:i];
            NSDate *dateKey = [Helpers dateFromString:strDateKey];
            if ([self.calendarView date:eventDateTime isSameDayAsDate:dateKey]) {
                
                aldyExist = YES;
                NSMutableArray *currentDates = [self.selectedCalendarDatesDict objectForKey:strDateKey];
                [currentDates addObject:eventDateTime];
                [self.selectedCalendarDatesDict setObject:currentDates forKey:strDateKey];
                break;
            }
        }
        
        if (!aldyExist) {
            
            NSString *key = [Helpers stringFromDate:eventDateTime];
            NSMutableArray *dates = [[NSMutableArray alloc] initWithObjects:eventDateTime, nil];
            [self.selectedCalendarDatesDict setObject:dates forKey:key];
        }
    }
    
    
    
    for (NSString *strDateKey in self.selectedCalendarDatesDict.allKeys) {
        
        NSDate *dateKey = [Helpers dateFromString:strDateKey];
        NSMutableArray *dates = [self.selectedCalendarDatesDict objectForKey:strDateKey];
        
        RDPieView *view = [[RDPieView alloc] initWithFrame:CGRectMake(3.5, 2.5, 30, 30)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:666];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:10.0]];
        
        [view addSubview:label];
        
        if (dates.count == 1) { // single cell
            
            if ([Helpers isDay:dateKey])
                [view setAMRatio:1 setPMRatio:0];
            else
                [view setAMRatio:0 setPMRatio:1];
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"hh:mm"];
            NSString *dateString2 = [dateFormatter2 stringFromDate:dateKey];
            NSString *displayString2 = dateString2;
            [label setText:displayString2];
            [view setUserInteractionEnabled:NO];
            
        }
        else if(dates.count>1) { // multi-dates cell
            
            int amCount = 0; int pmCount = 0;
            for (NSDate *date in dates) {
                
                if ([Helpers isDay:date])
                    amCount++;
                else
                    pmCount++;
            }
            if (pmCount == 0) [view setAMRatio:1 setPMRatio:0];
            else if (amCount == 0) [view setAMRatio:0 setPMRatio:1];
            else {
            
                float total = amCount + pmCount;
                float amRatio = amCount/total;
                [view setAMRatio:amRatio setPMRatio:1-amRatio];
            }
            
            
            
            [label setText:@"..."];
            
            [view setUserInteractionEnabled:NO];
        }
        
        [selectedCalendarDates addObject:dateKey];
        [self.viewsForSelectedCalendarDates addObject:view];
    }
    
    [self.calendarView setSubviews:self.viewsForSelectedCalendarDates toDateButtonWithDate:selectedCalendarDates];
    [self.calendarView reloadData];
}

#pragma mark - Create Event Methods

-(void)getNewInviteCode {
 
    [[NetworkAPIClient sharedClient] POST:GENERATE_INVITE_CODE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.invitationCode = [responseObject objectForKey:@"invitation_code"];
        NSLog(@"invitation code: %@", self.invitationCode);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Retrieve invite code failed");
    }];
}

-(void)createEvent {
    
//    if ([[self.txtEventName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || !self.selectedLocationDict || self.eventDateTimesArray.count <= 0) {
//        
//        UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Missing Event Data" message:@"Oops! We can't create an event for you without an Event Name, a Location, and the selected Dates." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        
//        [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
//        }];
//        
//        return;
//    }
//    
    if ([self getSelectedEmails].count<=0) {
        
        UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"You Have No Guests!" message:@"Oops! It's going to be a pretty boring event if you are going alone. How about inviting some of your friends?" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            
            [self selectContactsAction];
        }];
        
        return;
    }
    
    if ([[self.creatorNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [[self.creatorEmailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        
        UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"We Don't Know Who You Are!" message:@"We need your name and email address in order to start this event. Otherwise your invitees won't know who created the event! Do fill up the relevant fields please, thanks!" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            
            [self selectContactsAction];
        }];
        
        return;
    }
    
    CGFloat latitude = [[self.selectedLocationDict objectForKey:@"latitude"] floatValue];
    CGFloat longitude = [[self.selectedLocationDict objectForKey:@"longitude"] floatValue];
    NSString *placeName = [self.selectedLocationDict objectForKey:@"name"];
    NSString *placeAddress = [self.selectedLocationDict objectForKey:@"address"];
    

    
    
    NSString *dateString = @"";
    for (NSDate *date in self.eventDateTimesArray) {

        dateString = [dateString stringByAppendingString:[Helpers stringFromDate:date]];
        dateString = [dateString stringByAppendingString:@","];
    }
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [queryInfo setObject:self.txtEventName.text forKey:@"event_name"];
    
    [queryInfo setObject:self.invitationCode forKey:@"invitation_code"];
//    [queryInfo setObject:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
//    [queryInfo setObject:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
  //  [queryInfo setObject:placeName forKey:@"place_name"];
    
    if (placeAddress)
//        [queryInfo setObject:placeAddress forKey:@"address"];
    
    [queryInfo setObject:self.txtDescription.text forKey:@"description"];
    [queryInfo setObject:dateString forKey:@"datetime"];
    
    NSString *invitees = @"";
    
    
    
    for (NSDictionary *contact in self.contactsWithEmail) {
        
        if ([[contact objectForKey:@"selected"] boolValue]) {
            
            invitees = [invitees stringByAppendingString:[contact objectForKey:@"name"]];
            invitees = [invitees stringByAppendingString:@","];
            invitees = [invitees stringByAppendingString:[contact objectForKey:@"email"]];
            invitees = [invitees stringByAppendingString:@"{"];
        }
    }
    
    NSMutableDictionary *hStoreDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [hStoreDict setObject:self.invitationCode forKey:@"invitation_code"];
    [hStoreDict setObject:self.txtDescription.text forKey:@"description"];
    [hStoreDict setObject:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    [hStoreDict setObject:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    [hStoreDict setObject:placeAddress forKey:@"address"];
    [hStoreDict setObject:placeName forKey:@"place_name"];
    [hStoreDict setObject:[NSNumber numberWithFloat:0]  forKey:@"confirm_state"];
    [hStoreDict setObject:@"" forKey:@"confirmed_date"];
    
    if (hStoreDict) {
        
        NSString *dataStr = @"{";
        
        for (id key in hStoreDict) {
            
            NSString *keyStr = key;
            NSString *valueStr = hStoreDict[key];
            
            NSString *kvStr = [NSString stringWithFormat:@"%@:%@,", keyStr, valueStr];
            
            dataStr = [dataStr stringByAppendingString:kvStr];
        }
        
        dataStr = [dataStr stringByPaddingToLength:dataStr.length-1 withString:nil startingAtIndex:0];
        
        dataStr = [dataStr stringByAppendingString:@"}"];
        
        //string must drop two chars ", "
        //add "} "
        
        [queryInfo setObject:dataStr forKey:@"data"];
    }

    [queryInfo setObject:invitees forKey:@"invitees"];
    
    [queryInfo setObject:self.creatorNameField.text forKey:@"username"];
    [queryInfo setObject:self.creatorEmailField.text forKey:@"email"];
    
    NSLog(@"Query INFO :::: %@",queryInfo);
    
    [[NetworkAPIClient sharedClient] POST:CREATE_EVENT parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"create event success");
//        [self sendInvitationCodeToInvitees];
        
        [self closeButtonAction];
        
        [(MainVC *)self.parentVC openEventVC:[NSString stringWithFormat:@"%@", self.invitationCode] username:self.creatorNameField.text andEmail:self.creatorEmailField.text];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"creat event failed with error: %@", error);
    }];
}

#pragma mark - Keyboard Methods

-(void)keyboardWillShow:(NSNotification *)notification {
    
    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downSwipe];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.dateTimeTable setHidden:YES];
    
    [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0.0 options:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] animations:^{
        
        [self.selectDatesButton setFrame:CGRectMake(self.selectDatesButton.frame.origin.x, 215, self.selectDatesButton.frame.size.width, self.selectDatesButton.frame.size.height)];
        [self.selectContactsButton setFrame:CGRectMake(self.selectContactsButton.frame.origin.x, 249, self.selectContactsButton.frame.size.width, self.selectContactsButton.frame.size.height)];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    [self.view removeGestureRecognizer:downSwipe];
    [self.view removeGestureRecognizer:tapGesture];
    
    [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0.0 options:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] animations:^{
        
        [self.selectDatesButton setFrame:CGRectMake(self.selectDatesButton.frame.origin.x, 432, self.selectDatesButton.frame.size.width, self.selectDatesButton.frame.size.height)];
        [self.selectContactsButton setFrame:CGRectMake(self.selectContactsButton.frame.origin.x, 466, self.selectContactsButton.frame.size.width, self.selectContactsButton.frame.size.height)];
        
    } completion:^(BOOL finished) {
        
        if (self.mainScrollView.contentOffset.x == 640.0) {
            //at contacts selection
            [self.dateTimeTable setHidden:YES];
        }
        else {
            [self.dateTimeTable setHidden:NO];
        }
    }];
}

-(void)hideKeyboard {
    
    [self.txtEventName resignFirstResponder];
    [self.txtDescription resignFirstResponder];
    [self.txtPlaceName resignFirstResponder];
    [self.txtCityName resignFirstResponder];
    [self.creatorEmailField resignFirstResponder];
    [self.creatorNameField resignFirstResponder];
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.txtPlaceName || self.txtCityName) {
        
        [self searchForPlacesOnServer];
    }
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(RDLabeledTextView *)textView {
    
    if (textView == self.txtDescription) {
        
        if (locationPickerShown) {
            [self hideLocationPicker];
            [self hideKeyboard];
            return NO;
        }
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(RDLabeledTextView *)textView {
    
    if (textView == self.txtDescription) {
        
        if (![textView.textView.text isEqualToString:@""]) {
            
            [self.btnTxtDescriptionClearButton setHidden:NO];
        }
    }
}

-(void)textViewDidChange:(RDLabeledTextView *)textView {
    
    if (textView == self.txtDescription) {
        
        if (![textView.textView.text isEqualToString:@""]) {
         
            [self.btnTxtDescriptionClearButton setHidden:NO];
        }
    }
}

-(void)textViewDidEndEditing:(RDLabeledTextView *)textView {
    
    if (textView == self.txtDescription) {
        
        [self.btnTxtDescriptionClearButton setHidden:YES];
    }
}

-(IBAction)clearTxtDescriptionField {
    
    [self.txtDescription setText:@""];
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

#pragma mark - Get Location Methods

-(void)searchForPlacesOnServer {
    
    [self hideKeyboard];
    
    [[NetworkAPIClient sharedStagingClient] cancelHTTPOperationsWithPath:PLACES_WITHIN_LOCATION];
    [[NetworkAPIClient sharedStagingClient] cancelHTTPOperationsWithPath:PLACES_CHECKIN_SEARCH_NEARBY_PLACES];
    [[NetworkAPIClient sharedStagingClient] cancelHTTPOperationsWithPath:PLACES_WITHIN_LOCALITY];
    
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
//    else if ([locationKeyword isEqualToString:@""] && ![cityKeyword isEqualToString:@""]) {
//        
//        //has city keyword no location keyword
//        //alert user to input location keyword
//        
//        UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Missing main keyword" message:@"Please enter the main search keyword together with your city keyword." cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
//            
//        }];
//        
//        return;
//    }
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
    self.selectedLocationDict = nil;
    
    [[NetworkAPIClient sharedStagingClient] POST:path parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
        self.selectedLocationDict = nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.arFilteredPlaces removeAllObjects];
        
        [self.txtPlaceName setText:@""];
        
        [self.placesTable reloadData];
        self.selectedLocationDict = nil;
    }];
}

#pragma mark Contacts and Email Methods

-(void)checkAddressBookAccess {
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // the app is authorized to access the first time
                
                [self getContactsWithEmail];
                
            } else { // the app is not authorized to access the address book
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access to contacts Is Denied" message:@"User denied the access to the contacts" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                });
                
                
                // Show an alert here if user denies access telling that the contact cannot be added because you didn't allow it to access the contacts
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // If the user user has earlier provided the access, then add the contact
        
        [self getContactsWithEmail];
        
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        // If the user user has NOT earlier provided the access, create an alert to tell the user to go to Settings app and allow access
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Denied!" message:@"Access to address book data for this app is explicitly denied before. You can grant the permission in your setting." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Denied!" message:@"Access to address book data is not allowed under your current access right on this phone." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(NSArray*)getContactsWithEmail {
    
    NSString* name = @"";
    NSString* email = @"";
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef aPerson = CFArrayGetValueAtIndex( allPeople, i );
        
        ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
        ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
        
        //        ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);
        ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
        
        NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
        
        
        if ([emailArray count] > 0) {
            
            email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
            
            if (fnameProperty != nil) {
                name = [NSString stringWithFormat:@"%@", fnameProperty];
            }
            if (lnameProperty != nil) {
                name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", lnameProperty]];
            }
            
            NSMutableDictionary *contact = [[NSMutableDictionary alloc] initWithCapacity:0];
            [contact setObject:name forKey:@"name"];
            [contact setObject:email forKey:@"email"];
            [contact setObject:[NSNumber numberWithBool:NO] forKey:@"selected"];
            [self.contactsWithEmail addObject:contact];
        }
    }
    
    return self.contactsWithEmail;
}

-(void)sendInvitationCodeToInvitees {

    if (![MFMailComposeViewController canSendMail]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You device is not set up for email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    MFMailComposeViewController *mailcompose = [[MFMailComposeViewController alloc] init];
    
    NSString *eventBaseURL = @"http://socal-staging.herokuapp.com/use_invitation?i_code=";
//    NSString *eventBaseURL = @"http://rayd.us/socal/";
    NSString *eventURL = [NSString stringWithFormat:@"%@%@", eventBaseURL, self.invitationCode];
    NSString *appURL = [NSString stringWithFormat:@"socal://open_event?invitation_code=%@", self.invitationCode];
    
    NSString *messageBody = [NSString stringWithFormat:@"<html><p>You have been invited to <strong>%@</strong>.</p><p>The invitation code for this event is <strong>%@</strong>. Click this <a href=%@>link</a> to open it directly if you have the SoCal app installed on your device. You can also scan the QR Code via the app, or enter the invitation code manually.</p><p>Alternatively, access our web interface through this <a href=%@>link</a>.</p><p>See you there!</p></html>", self.txtEventName.text, self.invitationCode, appURL, eventURL];
    
    UIImage *qrCode = [UIImage mdQRCodeForString:eventURL size:300.0];
    NSData *imageData = UIImageJPEGRepresentation(qrCode, 0.5);
    
    mailcompose = [[MFMailComposeViewController alloc] init];
    mailcompose.mailComposeDelegate = self;
    [mailcompose setSubject:@"You have been invited to an Event!"];
    [mailcompose setMessageBody:messageBody isHTML:YES];
    [mailcompose addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@.jpg",self.invitationCode]];
    [mailcompose setToRecipients:[self getSelectedEmails]];
    
    [(MainVC *)self.parentVC presentViewController:mailcompose animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
        {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Email Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
    
//    [self.navigationController popViewControllerAnimated:NO];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [controller dismissViewControllerAnimated:NO completion:^{
        [self closeButtonAction];
    }];
}

-(NSArray*)getSelectedEmails {

    NSMutableArray *selectedEmails = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *contact in self.contactsWithEmail) {
        
        if ([[contact objectForKey:@"selected"] boolValue]) {
            [selectedEmails addObject: [contact objectForKey:@"email"]];
        }
    }
    return (NSArray*)selectedEmails;
}

#pragma mark - UIAlertView Delegates

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) { //
        NSLog(@"0");
    }
    if (buttonIndex == 1) {
        NSLog(@"1");
    }
}


@end
