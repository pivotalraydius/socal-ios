//
//  ComposeVC.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "ComposeVC.h"
#import "ComposeDateTimeCell.h"
#import "RDPieView.h"
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

-(void)setupTestData {
    
    self.selectedContactsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedCalendarDatesDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.viewsForSelectedCalendarDates = [[NSMutableArray alloc] initWithCapacity:0];
    
    currentlySelectedDateTimeCell = -1;
}

-(void)setupMainScrollView {
    
    [self.mainScrollView addSubview:self.composeEventContainer];
    
    [self.composeEventContainer setFrame:CGRectMake(0, 0, self.composeEventContainer.frame.size.width, self.composeEventContainer.frame.size.height)];
    
    [self setupComposeEventContainer];
    
//    [self.mainScrollView addSubview:self.timeSelectionContainer];
    
    [self.timeSelectionContainer setFrame:CGRectMake(320, 0, self.timeSelectionContainer.frame.size.width, self.timeSelectionContainer.frame.size.height)];
    
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
    [self.calendarView setDateFont:[UIFont systemFontOfSize:10.0]];
    [self.calendarView setTitleFont:[UIFont systemFontOfSize:14.0]];
 
    [self.calendarView setDelegate:self];
}

-(void)scrollToTimeSelection {
    
    [self.mainScrollView setContentOffset:CGPointMake(320.0, 0.0) animated:YES];
}

-(void)scrollToComposeEvent {
    
    [self.mainScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    while (self.mainScrollView.subviews.count>0) {
    
        [[[self.mainScrollView subviews] lastObject] removeFromSuperview];
    }
    
}

#pragma mark - Main Actions

-(IBAction)closeButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dateSelectionDoneButtonAction {
    
    [self scrollToComposeEvent];

}

-(IBAction)doneButtonAction {
    
    [self createEvent];
}

-(IBAction)selectDatesAction {
    
    [self.mainScrollView addSubview:self.timeSelectionContainer];
    [self scrollToTimeSelection];
}

-(IBAction)selectContactsAction {

    if (!self.contactsPicker) {
        self.contactsPicker = [[ABPeoplePickerNavigationController alloc] init];
        self.contactsPicker.peoplePickerDelegate = self;
    }
    
    
    [self.timeSelectionContainer addSubview: self.contactsPicker.view];
    [self scrollToTimeSelection];
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
    
    return self.eventDateTimesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ComposeDateTimeCell *cell = (ComposeDateTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"ComposeDateTimeCell"];
    
    if (!cell) {
        cell = [ComposeDateTimeCell newComposeDateTimeCell];
        [cell setParentVC:self];
    }
    
    [cell renderCellDataWithDate:[self.eventDateTimesArray objectAtIndex:indexPath.row] andIndexPathRow:indexPath.row];
     
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == currentlySelectedDateTimeCell) {
        
        return 80.0;
    }
    
    return 30.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == currentlySelectedDateTimeCell) {
        
        //already selected, deselect
        [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
    
    currentlySelectedDateTimeCell = indexPath.row;
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
    [self.dateTimeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.eventDateTimesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    currentlySelectedDateTimeCell = -1;
    
    [tableView beginUpdates];
    [tableView endUpdates];
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

#pragma mark - People picker delegate methods

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.contactsPicker.view removeFromSuperview];
    [self scrollToComposeEvent];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
//    [self displayPerson:person];
//    [self dismissModalViewControllerAnimated:YES];
    
    [self addContact:person];
    ABPersonViewController *personVC = [[ABPersonViewController alloc] init];
    [personVC setHighlightedItemForProperty:kABPersonPhoneProperty withIdentifier:0];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

-(void)addContact:(ABRecordRef)aPerson {
    
    NSString* name = @"";
    NSString* phone = @"";
    NSString* email = @"";
    
    ABMultiValueRef fnameProperty = ABRecordCopyValue(aPerson, kABPersonFirstNameProperty);
    ABMultiValueRef lnameProperty = ABRecordCopyValue(aPerson, kABPersonLastNameProperty);
    
    ABMultiValueRef phoneProperty = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);\
    ABMultiValueRef emailProperty = ABRecordCopyValue(aPerson, kABPersonEmailProperty);
    
    NSArray *emailArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailProperty);
    NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneProperty);
    
    
    if (fnameProperty != nil) {
        name = [NSString stringWithFormat:@"%@", fnameProperty];
    }
    if (lnameProperty != nil) {
        name = [name stringByAppendingString:[NSString stringWithFormat:@" %@", lnameProperty]];
    }
    
    if ([phoneArray count] > 0) {
        if ([phoneArray count] > 1) {
            for (int i = 0; i < [phoneArray count]; i++) {
                phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@\n", [phoneArray objectAtIndex:i]]];
            }
        }else {
            phone = [NSString stringWithFormat:@"%@", [phoneArray objectAtIndex:0]];
        }
    }
    
    if ([emailArray count] > 0) {
        if ([emailArray count] > 1) {
            for (int i = 0; i < [emailArray count]; i++) {
                email = [email stringByAppendingString:[NSString stringWithFormat:@"%@\n", [emailArray objectAtIndex:i]]];
            }
        }else {
            email = [NSString stringWithFormat:@"%@", [emailArray objectAtIndex:0]];
        }
    }

    NSLog(@"NAME : %@",name);
    NSLog(@"PHONE: %@",phone);
    NSLog(@"EMAIL: %@",email);
    NSLog(@"\n");
    
    NSMutableDictionary *contact = [[NSMutableDictionary alloc] initWithCapacity:0];
    [contact setObject:name forKey:@"name"];
    [contact setObject:email forKey:@"email"];
    [self.selectedContactsArray addObject:contact];
}

-(void)sendInvitationCodeToInvitees {

    if (![MFMailComposeViewController canSendMail]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You device is not set up for email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSMutableArray *recipients = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *person in self.selectedContactsArray) {
        
        [recipients addObject:[person objectForKey:@"email"]];
    }
    
    
    self.mailComposeVC = [[MFMailComposeViewController alloc] init];
    self.mailComposeVC.mailComposeDelegate = self;
    [self.mailComposeVC setSubject:@"you are invited to an event"];
    [self.mailComposeVC setMessageBody:[NSString stringWithFormat:@"invitation code : %@", self.invitationCode] isHTML:NO];
     [self.mailComposeVC setToRecipients:recipients];
     [self.navigationController presentViewController:self.mailComposeVC animated:YES completion:^{
        
    }];
    
}

@end
