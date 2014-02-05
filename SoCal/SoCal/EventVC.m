//
//  EventVC.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "EventVC.h"

@implementation EventVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        hasName = NO;
        self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedDateItems = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedDateItemsViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        
        hasName = NO;
        self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedDateItems = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedDateItemsViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self retrieveEvent];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    
    [self.mainScrollView addSubview:self.detailsView];
    [self.mainScrollView addSubview:self.datesView];
    [self.mainScrollView addSubview:self.doneView];
    
    [self.mainScrollView setScrollEnabled:NO];
    
    [self.detailsView setFrame:CGRectMake(0.0, 0.0, 320.0, self.detailsView.frame.size.height)];
    [self.datesView setFrame:CGRectMake(320.0, 0.0, 320.0, self.datesView.frame.size.height)];
    [self.doneView setFrame:CGRectMake(640.0, 0.0, 320.0, self.doneView.frame.size.height)];
    
    [self.svEventInfoScrollView addSubview:self.detailsInfoView];
    [self.svEventInfoScrollView addSubview:self.detailsLocationView];
    
    [self.detailsInfoView setFrame:CGRectMake(0.0, self.detailsInfoView.frame.origin.y, self.detailsInfoView.frame.size.width, self.detailsInfoView.frame.size.height)];
    [self.detailsLocationView setFrame:CGRectMake(320.0, self.detailsLocationView.frame.origin.y, self.detailsLocationView.frame.size.width, self.detailsLocationView.frame.size.height)];
    
    [self.svEventInfoScrollView setContentSize:CGSizeMake(self.svEventInfoScrollView.frame.size.width*2, self.svEventInfoScrollView.frame.size.height)];
    
    [self.svEventInfoScrollView setPagingEnabled:YES];
    
    [self.bottomBar addSubview:self.postsInputView];
    [self.bottomBar addSubview:self.nameInputView];
    
    [self setBottomBarMode];
    
    [self.btnNameOkButton.layer setCornerRadius:3.0];
    [self.btnPostButton.layer setCornerRadius:3.0];
    [self.eventDateYesPiece.layer setCornerRadius:self.eventDateYesPiece.frame.size.height/2];
    [self.eventDateNoPiece.layer setCornerRadius:self.eventDateNoPiece.frame.size.height/2];
    [self.eventDateMaybePiece.layer setCornerRadius:self.eventDateMaybePiece.frame.size.height/2];
    
    [self setupCalendar];
}

-(void)retrieveEvent {
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    [queryInfo setObject:self.eventInviteCode forKey:@"invitation_code"];
    
    [[NetworkAPIClient sharedClient] postPath:RETRIEVE_EVENT parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *eventDict = [responseObject objectForKey:@"topic"];
        
        //set labels
        [self setEventTitleWithTitle:[eventDict objectForKey:@"title"] place:[eventDict objectForKey:@"place_name"] andDate:nil];
        [self.lblDetailsInfo setText:[eventDict objectForKey:@"description"]];
        
        //set map
        CGFloat lat = [[eventDict objectForKey:@"latitude"] floatValue];
        CGFloat lng = [[eventDict objectForKey:@"longitude"] floatValue];
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        region.center = CLLocationCoordinate2DMake(lat, lng);
        [self.detailsMapView setRegion:region animated:YES];
        
        NSArray *dateStringsArray = [eventDict objectForKey:@"datetime"];
        
        for (NSDictionary *dateDict in dateStringsArray) {
            
            [self.eventDateTimesArray addObject:[Helpers dateFromString:[dateDict objectForKey:@"dateNtime"]]];
        }
        
        [self updateCalendarSubviews];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"retrieve event failed with error: %@", error);
    }];
}

-(void)updateEventDateTimeArrayWith:(NSString *)datetimeString {
    
    
}

-(void)setEventTitleWithTitle:(NSString *)title place:(NSString *)placeName andDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, EEEE, hh:mm a"];
    [dateFormatter setAMSymbol:@"am"];
    [dateFormatter setPMSymbol:@"pm"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if (title && placeName && date) {
        [self.lblDetailsEventTitle setText:[NSString stringWithFormat:@"%@, %@ at %@", title, dateString, placeName]];
    }
    else if (title && placeName) {
        [self.lblDetailsEventTitle setText:[NSString stringWithFormat:@"%@, Date Uncomfirmed, at %@", title, placeName]];
    }
    else if (title && date) {
        [self.lblDetailsEventTitle setText:[NSString stringWithFormat:@"%@, %@, Location Unconfirmed", title, dateString]];
    }
    else {
        [self.lblDetailsEventTitle setText:[NSString stringWithFormat:@"%@, Date and Location Unconfirmed", title]];
    }
}

-(void)updateCalendarSubviews {
    
    [self.selectedDateItems removeAllObjects];
    [self.selectedDateItemsViews removeAllObjects];
    
    NSMutableArray *multiInDay = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDate *dateToAdd in self.eventDateTimesArray) {
        
        if ([self.selectedDateItems lastObject]) {
            
            if ([self.calEventDatesCalendar date:[self.selectedDateItems lastObject] isSameDayAsDate:dateToAdd]) {
                
                //don't add
                [multiInDay addObject:dateToAdd];
                [self.selectedDateItems removeObject:[self.selectedDateItems lastObject]];
            }
            else {
                [self.selectedDateItems addObject:dateToAdd];
            }
        }
        else {
            [self.selectedDateItems addObject:dateToAdd];
        }
    }
    
    for (NSDate *dateToAdd in self.selectedDateItems) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(3.5, 2.5, 30, 30)];
        [view setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
        [view.layer setCornerRadius:view.frame.size.height/2];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:10.0]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d, EEEE, hh:mm a"];
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];
        
        NSString *dateString = [dateFormatter stringFromDate:dateToAdd];
        
        if ([dateString hasSuffix:@"am"]) {
            [view setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
        }
        else {
            [view setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
        }
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"hh:mm"];
        
        NSString *dateString2 = [dateFormatter2 stringFromDate:dateToAdd];
        NSString *displayString2 = dateString2;
        [label setText:displayString2];
        
        [view addSubview:label];
        
        [view setTag:666];
        [view setUserInteractionEnabled:NO];
        
        [self.selectedDateItemsViews addObject:view];
    }
    
    
    for (NSDate *dateToAdd in multiInDay) {
        
        //TO DO make the half-circle view here
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(3.5, 2.5, 30, 30)];
        [view setBackgroundColor:[UIColor redColor]];
        [view.layer setCornerRadius:view.frame.size.height/2];
        
        [view setTag:666];
        [view setUserInteractionEnabled:NO];
        
        [self.selectedDateItems addObject:dateToAdd];
        [self.selectedDateItemsViews addObject:view];
    }
    
    [self.calEventDatesCalendar setSubviews:self.selectedDateItemsViews toDateButtonWithDate:self.selectedDateItems];
    [self.calEventDatesCalendar reloadData];
}

#pragma mark - View Action Methods

-(IBAction)backButtonAction {
    
    if (self.mainScrollView.contentOffset.x == 0.0) {
        //close eventVC
        [self closeEventVC];
    }
    else if (self.mainScrollView.contentOffset.x == 320.0) {
        //back to details
        [self scrollToDetailsView];
    }
    else if (self.mainScrollView.contentOffset.x == 640.0) {
        //back to dates
        [self scrollToDatesView];
    }
}

-(IBAction)forwardButtonAction {
    
    if (self.mainScrollView.contentOffset.x == 0.0) {
        //forward to dates
        [self scrollToDatesView];
    }
    else if (self.mainScrollView.contentOffset.x == 320.0) {
        //forward to done
        [self scrollToDoneView];
    }
    else if (self.mainScrollView.contentOffset.x == 640.0) {
        //close eventVC
        [self closeEventVC];
    }
}

-(void)closeEventVC {
 
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollToDatesView {
    
    [self.mainScrollView setContentOffset:CGPointMake(320.0, 0.0) animated:YES];
}

-(void)scrollToDoneView {
    
    [self.mainScrollView setContentOffset:CGPointMake(640.0, 0.0) animated:YES];
}

-(void)scrollToDetailsView {
    
    [self.mainScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

-(IBAction)scrollToDetailsMapView {
    
    [self.svEventInfoScrollView setContentOffset:CGPointMake(320.0, self.detailsLocationView.frame.origin.y) animated:YES];
}

-(IBAction)scrollToDetailsInfoView {
    
    [self.svEventInfoScrollView setContentOffset:CGPointMake(0.0, self.detailsInfoView.frame.origin.y) animated:YES];
}

#pragma mark - Bottom Bar Methods

-(void)setBottomBarMode {
    
    if (hasName) {
        [self.postsInputView setHidden:NO];
        [self.nameInputView setHidden:YES];
        [self.lblEnterNamePrompt setHidden:YES];
    }
    else {
        [self.postsInputView setHidden:YES];
        [self.nameInputView setHidden:NO];
        [self.lblEnterNamePrompt setHidden:NO];
    }
}

-(IBAction)btnNameOkAction {
    
    [self hideKeyboard];
    
    self.eventUserName = self.txtNameField.text;
    hasName = YES;
    
    [self setBottomBarMode];
}

#pragma mark - Posts Methods

-(IBAction)btnPostAction {
    
}

#pragma mark - Calendar Methods

-(void)setupCalendar {
    
    [self.calEventDatesCalendar setOnlyShowCurrentMonth:NO];
    
    [self.calEventDatesCalendar setBackgroundColor:[UIColor whiteColor]];
    [self.calEventDatesCalendar setInnerBorderColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    [self.calEventDatesCalendar setDayOfWeekTextColor:[UIColor whiteColor]];
    [self.calEventDatesCalendar setDateFont:[UIFont systemFontOfSize:10.0]];
    [self.calEventDatesCalendar setTitleFont:[UIFont systemFontOfSize:14.0]];
    
//    [self.calEventDatesCalendar setDelegate:self];
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainScrollView) {
        
        [self.postsTable setHidden:NO];
        [self.bottomBar setHidden:NO];
        
        [self.postsTable setFrame:CGRectMake(self.postsTable.frame.origin.x, 314, self.postsTable.frame.size.width, self.postsTable.frame.size.height)];
        
        if (scrollView.contentOffset.x < 320.0) {
            
            [self.mainBackButton setTitle:@"Home" forState:UIControlStateNormal];
            [self.mainDoneButton setTitle:@"Dates" forState:UIControlStateNormal];
            [self.lblTitleLabel setText:@"Details"];
        }
        else if (scrollView.contentOffset.x < 640.0) {
            
            [self.mainBackButton setTitle:@"Details" forState:UIControlStateNormal];
            [self.mainDoneButton setTitle:@"Done" forState:UIControlStateNormal];
            [self.lblTitleLabel setText:@"Dates"];
            
            [self.postsTable setFrame:CGRectMake(self.postsTable.frame.origin.x, 377, self.postsTable.frame.size.width, self.postsTable.frame.size.height)];
        }
        else if (scrollView.contentOffset.x < 920.0) {
            
            [self.mainBackButton setTitle:@"Dates" forState:UIControlStateNormal];
            [self.mainDoneButton setTitle:@"Done" forState:UIControlStateNormal];
            [self.lblTitleLabel setText:@"Done"];
            
            [self.postsTable setHidden:YES];
            [self.bottomBar setHidden:YES];
        }
        
        if  (self.bottomBar.hidden) [self.lblEnterNamePrompt setHidden:YES];
        else {
            if (hasName) [self.lblEnterNamePrompt setHidden:YES];
            else [self.lblEnterNamePrompt setHidden:NO];
        }
    }
}

#pragma mark - Keyboard Methods

-(void)keyboardWillShow:(NSNotification *)notification {
    
    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downSwipe];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];

    [self.bottomBar setFrame:CGRectMake(0, self.view.frame.size.height - self.bottomBar.frame.size.height - 216, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
    [self.lblEnterNamePrompt setFrame:CGRectMake(self.lblEnterNamePrompt.frame.origin.x, self.bottomBar.frame.origin.y - self.lblEnterNamePrompt.frame.size.height, self.lblEnterNamePrompt.frame.size.width, self.lblEnterNamePrompt.frame.size.height)];
    
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    [self.view removeGestureRecognizer:downSwipe];
    [self.view removeGestureRecognizer:tapGesture];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.bottomBar setFrame:CGRectMake(0, self.view.frame.size.height - self.bottomBar.frame.size.height, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
    [self.lblEnterNamePrompt setFrame:CGRectMake(self.lblEnterNamePrompt.frame.origin.x, self.bottomBar.frame.origin.y - self.lblEnterNamePrompt.frame.size.height, self.lblEnterNamePrompt.frame.size.width, self.lblEnterNamePrompt.frame.size.height)];
    
    [UIView commitAnimations];
}

-(void)hideKeyboard {
    
    [self.txtNameField resignFirstResponder];
    [self.txtPostField resignFirstResponder];
}

@end
