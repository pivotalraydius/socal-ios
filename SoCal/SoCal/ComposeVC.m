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
#import <MessageUI/MessageUI.h>

@implementation ComposeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTestData];
    [self setupMainScrollView];
    [self setupFonts];
    
    [self getNewInviteCode];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.selectedLocationDict) {
        [self.lblBtnLocation setText:[self.selectedLocationDict objectForKey:@"name"]];
    }
    else {
        [self.lblBtnLocation setText:@"Location"];
    }
    
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

-(void)setupFonts {
    
    [self.mainTitleLabel setFont:[Helpers Exo2Regular:24.0]];
    
    [self.dateTimeDoneButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    [self.closeButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    [self.doneButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    
    [self.txtEventName setTextFont:[Helpers Exo2Regular:14.0]];
    [self.txtEventName setTitleFont:[Helpers Exo2Regular:18.0]];
    
    [self.txtDescription setTextFont:[Helpers Exo2Regular:14.0]];
    [self.txtDescription setTitleFont:[Helpers Exo2Regular:18.0]];
    
    [self.lblBtnLocation setFont:[Helpers Exo2Regular:18.0]];
    
    [self.selectDatesButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    [self.selectContactsButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    
    [self.contactDoneButton.titleLabel setFont:[Helpers Exo2Regular:14.0]];
}

-(void)setupTestData {
    
    self.contactsWithEmail = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedContacts = [[NSMutableArray alloc] initWithCapacity:0];
    self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedCalendarDatesDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.viewsForSelectedCalendarDates = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self getContactsWithEmail];
    
    currentlySelectedDateTimeCell = -1;
}

-(void)setupMainScrollView {
    
    [self.mainScrollView addSubview:self.composeEventContainer];
    
    [self.composeEventContainer setFrame:CGRectMake(0, 0, self.composeEventContainer.frame.size.width, self.composeEventContainer.frame.size.height)];
    
    [self setupComposeEventContainer];
    
    [self.mainScrollView addSubview:self.timeSelectionContainer];
    [self.mainScrollView addSubview:self.contactsSelectionContainer];
    
    [self.timeSelectionContainer setFrame:CGRectMake(320, 0, self.timeSelectionContainer.frame.size.width, self.timeSelectionContainer.frame.size.height)];
    [self.contactsSelectionContainer setFrame:CGRectMake(320, 0, self.contactsSelectionContainer.frame.size.width, self.contactsSelectionContainer.frame.size.height)];
    
    [self setupTimeSelectionContainer];
    
    [self.mainScrollView setScrollEnabled:NO];
}

-(void)setupComposeEventContainer {
    
    [self.txtEventName setTitle:@"Event Name"];
    [self.txtDescription setTitle:@"Description"];
    
    [self.txtEventName setTitleColor:[Helpers bondiBlueColorWithAlpha:1.0]];
    [self.txtEventName setTextColor:[Helpers bondiBlueColorWithAlpha:1.0]];
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
    
    
    [self.calendarView setBackgroundColor:[UIColor whiteColor]];
    [self.calendarView setInnerBorderColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    [self.calendarView setDayOfWeekTextColor:[UIColor whiteColor]];
    [self.calendarView setDateFont:[Helpers Exo2Regular:11.0]];
    [self.calendarView setTitleFont:[Helpers Exo2Medium:14.0]];
 
    [self.calendarView setDelegate:self];
}

-(void)scrollToTimeSelection {
    
    [self.mainScrollView setContentOffset:CGPointMake(320.0, 0.0) animated:YES];
}

-(void)scrollToComposeEvent {
    
    [self.mainScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    [self.dateTimeTable setHidden:NO];
    
}

#pragma mark - Main Actions

-(IBAction)closeButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dateSelectionDoneButtonAction {
    
    [self scrollToComposeEvent];

}

-(IBAction)contactSelectionDoneButtonAction {
    
    [self scrollToComposeEvent];
}

-(IBAction)doneButtonAction {
    
    [self createEvent];
}

-(IBAction)selectDatesAction {
    
    [self.timeSelectionContainer setHidden:NO];
    [self.contactsSelectionContainer setHidden:YES];
    [self scrollToTimeSelection];
}

-(IBAction)selectContactsAction {

//    if (!self.contactsPicker) {
//        self.contactsPicker = [[ABPeoplePickerNavigationController alloc] init];
//        self.contactsPicker.peoplePickerDelegate = self;
//    }
//    
//
    [self.timeSelectionContainer setHidden:YES];
    [self.contactsSelectionContainer setHidden:NO];
    [self.dateTimeTable setHidden:YES];
    [self scrollToTimeSelection];
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
    
    LocationVC *locationVC = [[LocationVC alloc] init];
    [locationVC setParentVC:self];
    [self.navigationController pushViewController:locationVC animated:YES];
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
    
    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimePicker)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downSwipe];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimePicker)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)hideTimePicker {
    
    [self.view removeGestureRecognizer:downSwipe];
    downSwipe = nil;
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

#pragma mark - Table View Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.contactsTableview) {
        
        return self.contactsWithEmail.count;
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
    else {
        
        currentlySelectedDateTimeCell = -1;
        
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainScrollView) {
        
        if (scrollView.contentOffset.x >= 320.0) {
            
            [self.closeButton setHidden:YES];
            [self.doneButton setHidden:YES];
        }
        else {
            [self.closeButton setHidden:NO];
            [self.doneButton setHidden:NO];
        }
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
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d, EEEE, hh:mm a"];
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];
        
        if (dates.count == 1) { // single cell
            
            NSString *dateString = [dateFormatter stringFromDate:dateKey];
            
            if ([dateString hasSuffix:@"am"])
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
                
                NSString *dateString = [dateFormatter stringFromDate:date];
                
                if ([dateString hasSuffix:@"am"])
                    amCount++;
                else if ([dateString hasSuffix:@"pm"])
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
 
    [[NetworkAPIClient sharedClient] postPath:GENERATE_INVITE_CODE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.invitationCode = [responseObject objectForKey:@"invitation_code"];
        NSLog(@"invitation code: %@", self.invitationCode);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Retrieve invite code failed");
    }];
}

-(void)createEvent {
    
    if ([[self.txtEventName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || !self.selectedLocationDict || self.eventDateTimesArray.count <= 0) {
        
        NSLog(@"Missing data, cannot create event.");
        
        UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Missing Event Data" message:@"Oops! We can't create an event for you without an Event Name, a Location, and the selected Dates." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
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
    [queryInfo setObject:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    [queryInfo setObject:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    [queryInfo setObject:placeName forKey:@"place_name"];
    [queryInfo setObject:placeAddress forKey:@"address"];
    [queryInfo setObject:self.txtDescription.text forKey:@"description"];
    [queryInfo setObject:dateString forKey:@"datetime"];
    
    
    [[NetworkAPIClient sharedClient] postPath:CREATE_EVENT parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"create event success");
        [self sendInvitationCodeToInvitees];
        [self closeButtonAction];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"creat event failed with error: %@", error);
    }];
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
    
    [self.txtEventName resignFirstResponder];
    [self.txtDescription resignFirstResponder];
}

//#pragma mark - People picker delegate methods
//
//- (void)peoplePickerNavigationControllerDidCancel:
//(ABPeoplePickerNavigationController *)peoplePicker
//{
//    [self.contactsPicker.view removeFromSuperview];
//    [self scrollToComposeEvent];
//}
//
//
//- (BOOL)peoplePickerNavigationController:
//(ABPeoplePickerNavigationController *)peoplePicker
//      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
//    
////    [self displayPerson:person];
////    [self dismissModalViewControllerAnimated:YES];
//    
//    [self addContact:person];
//    ABPersonViewController *personVC = [[ABPersonViewController alloc] init];
//    [personVC setHighlightedItemForProperty:kABPersonPhoneProperty withIdentifier:0];
//    
//    return NO;
//}
//
//- (BOOL)peoplePickerNavigationController:
//(ABPeoplePickerNavigationController *)peoplePicker
//      shouldContinueAfterSelectingPerson:(ABRecordRef)person
//                                property:(ABPropertyID)property
//                              identifier:(ABMultiValueIdentifier)identifier
//{
//    return NO;
//}

-(NSArray*)getContactsWithEmail {
    
    NSString* name = @"";
//    NSString* phone = @"";
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
//            if ([emailArray count] > 1) {
//                for (int i = 0; i < [emailArray count]; i++) {
//                    email = [email stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:i]]];
//                }
//            }else {
//                email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
//            }
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
    
//    [self.contactsTableview reloadData];
    
    return self.contactsWithEmail;
    
//    NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
//    if ([phoneArray count] > 0) {
//        if ([phoneArray count] > 1) {
//            for (int i = 0; i < [phoneArray count]; i++) {
//                phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:i]]];
//            }
//        }else {
//            phone = [NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]];
//        }
//    }
    
    
    
}

-(void)sendInvitationCodeToInvitees {

    if (![MFMailComposeViewController canSendMail]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You device is not set up for email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    MFMailComposeViewController *mailcompose = [[MFMailComposeViewController alloc] init];
    
    NSString *eventURL = [NSString stringWithFormat:@"http://rayd.us/socal/%@",self.invitationCode];
    
    NSString *messageBody = [NSString stringWithFormat:@"<html><p>You have been invited to <strong>%@</strong>.</p><p>Scan the QR Code with your SoCal app or type in this invitation code <strong>%@</strong> manually.<p>&nbsp;</p>Alternatively, access our web interface through this <a href=%@>link</a>.</p><p>See you there!</p></html>", self.txtEventName.text, self.invitationCode,eventURL];
    
    UIImage *qrCode = [UIImage mdQRCodeForString:eventURL size:300.0];
    NSData *imageData = UIImageJPEGRepresentation(qrCode, 0.5);
    
    mailcompose = [[MFMailComposeViewController alloc] init];
    mailcompose.mailComposeDelegate = self;
    [mailcompose setSubject:@"You have been invited to an Event!"];
    [mailcompose setMessageBody:messageBody isHTML:YES];
    [mailcompose addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@.jpg",self.invitationCode]];
    [mailcompose setToRecipients:[self getSelectedEmails]];
    
    [self.navigationController presentViewController:mailcompose animated:NO completion:nil];
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
    
    [controller dismissViewControllerAnimated:NO completion:nil];
    

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


@end
