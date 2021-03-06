//
//  EventVC.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "EventVC.h"
#import "PostCell.h"
#import "PTPusherEvent.h"
#import "ListDateTimeCell.h"
#import "SummaryDateTimeCell.h"
#import "RDPieView.h"
#import "UIBAlertView.h"
#import "MainVC.h"

#define VOTE_BUTTON_STILL   0
#define VOTE_BUTTON_MOTION  1

#define VOTE_MAYBE 0
#define VOTE_YES   1
#define VOTE_NO    2

@implementation EventVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        hasName = NO;
        self.voteDictArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.eventDateTimesDictArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedCalendarDatesDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.viewsForSelectedCalendarDates = [[NSMutableArray alloc] initWithCapacity:0];
        self.postsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        
        hasName = NO;
        self.voteDictArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.eventDateTimesDictArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedCalendarDatesDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.viewsForSelectedCalendarDates = [[NSMutableArray alloc] initWithCapacity:0];
        self.postsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self setupFonts];
    
    [self retrieveEvent];
    [self initTouchForVoteButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupGradientMask];
    
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
    
    [self.eventDateYesPiece setBackgroundImage:[UIImage imageNamed:@"VoteYes.png"] forState:UIControlStateNormal];
    [self.eventDateNoPiece setBackgroundImage:[UIImage imageNamed:@"VoteNo.png"] forState:UIControlStateNormal];
    [self.eventDateMaybePiece setBackgroundImage:[UIImage imageNamed:@"VoteMaybe.png"] forState:UIControlStateNormal];
    
    [self.eventDateYesPiece setBackgroundColor:[UIColor clearColor]];
    [self.eventDateYesPiece setTitle:@"" forState:UIControlStateNormal];
    [self.eventDateNoPiece setBackgroundColor:[UIColor clearColor]];
    [self.eventDateNoPiece setTitle:@"" forState:UIControlStateNormal];
    [self.eventDateMaybePiece setBackgroundColor:[UIColor clearColor]];
    [self.eventDateMaybePiece setTitle:@"" forState:UIControlStateNormal];
    
    [self.eventDateConfirmSetPiece.layer setCornerRadius:self.eventDateMaybePiece.frame.size.height/2];
    
    [self.votingEndedAssistButton.titleLabel setNumberOfLines:2];
    [self.votingEndedAssistButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.votingEndedAssistButton.layer setBorderWidth:0.5];
    [self.votingEndedAssistButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.votingEndedAssistButton.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.votingEndedAssistButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.votingEndedAssistButton.layer setShadowOpacity:0.3];
    [self.votingEndedAssistButton.layer setShadowRadius:0.7];
    
    [self setupCalendar];
    
    [self.calListEventDatesTable setHidden:YES];
    
    if ([Helpers iPhone4]) {
        
        [self.postsTable setFrame:CGRectMake(self.postsTable.frame.origin.x, self.postsTable.frame.origin.y, self.postsTable.frame.size.width, self.postsTable.frame.size.height-88)];
        [self.bottomBar setFrame:CGRectMake(self.bottomBar.frame.origin.x, self.bottomBar.frame.origin.y-176, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
        [self.lblEnterNamePrompt setFrame:CGRectMake(self.lblEnterNamePrompt.frame.origin.x, self.lblEnterNamePrompt.frame.origin.y-88, self.lblEnterNamePrompt.frame.size.width, self.lblEnterNamePrompt.frame.size.height)];
    }
    
    [self.lblDetailsInfo.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.lblDetailsInfo.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.lblDetailsInfo.layer setShadowOpacity:0.3];
    [self.lblDetailsInfo.layer setShadowRadius:0.7];
    
    [self.lblDetailsEventTitle.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.lblDetailsEventTitle.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.lblDetailsEventTitle.layer setShadowOpacity:0.3];
    [self.lblDetailsEventTitle.layer setShadowRadius:0.7];
    
    [self.lblEventDateInstruction.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.lblEventDateInstruction.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.lblEventDateInstruction.layer setShadowOpacity:0.3];
    [self.lblEventDateInstruction.layer setShadowRadius:0.7];
    
    [self.eventDateRevotePiece.layer setCornerRadius:self.eventDateRevotePiece.frame.size.height/2];
}

-(void)setupFonts {
    
    [self.lblTitleLabel setFont:[Helpers Exo2Regular:24.0]];
    [self.mainBackButton.titleLabel setFont:[Helpers Exo2Regular:18.0]];
    [self.mainDoneButton.titleLabel setFont:[Helpers Exo2Regular:18.0]];
    
    [self.lblEnterNamePrompt setFont:[Helpers Exo2Regular:18.0]];
    [self.txtPostField setFont:[Helpers Exo2Regular:18.0]];
    [self.txtNameField setFont:[Helpers Exo2Regular:18.0]];
    [self.txtEmailField setFont:[Helpers Exo2Regular:18.0]];
    
    [self.btnPostButton.titleLabel setFont:[Helpers Exo2Regular:18.0]];
    [self.btnNameOkButton.titleLabel setFont:[Helpers Exo2Regular:18.0]];
    
    [self.votingEndedAssistButton.titleLabel setFont:[Helpers Exo2Regular:12.0]];
    
    [self.lblDetailsEventTitle setFont:[Helpers Exo2Regular:20.0]];
    
    [self.lblDetailsInfo setFont:[Helpers Exo2Regular:18.0]];
    
//    [self.eventDateYesPiece.titleLabel setFont:[Helpers Exo2Regular:14.0]];
//    [self.eventDateNoPiece.titleLabel setFont:[Helpers Exo2Regular:14.0]];
//    [self.eventDateMaybePiece.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    
    [self.eventDateRevotePiece.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    [self.eventDateConfirmSetPiece.titleLabel setFont:[Helpers Exo2Regular:14.0]];
    
    [self.lblEventDateInstruction setFont:[Helpers Exo2Regular:12.0]];
    [self.lblDoneSummaryLabel setFont:[Helpers Exo2Light:14.0]];
    [self.lblDoneSummaryLabel setTextColor:[UIColor whiteColor]];
    
    [self.lblDoneSummaryLabel.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.lblDoneSummaryLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.lblDoneSummaryLabel.layer setShadowOpacity:0.3];
    [self.lblDoneSummaryLabel.layer setShadowRadius:0.7];
    
    [self.multiDayOption1 setTextColor:[UIColor whiteColor]];
    [self.multiDayOption2 setTextColor:[UIColor whiteColor]];
    [self.multiDayOption3 setTextColor:[UIColor whiteColor]];
    [self.multiDayOption4 setTextColor:[UIColor whiteColor]];
}

-(void)setupGradientMask {
    
    if (!maskLayer)
    {
        maskLayer = [CAGradientLayer layer];
        
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
        CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
        
        maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                            (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.1],
                               [NSNumber numberWithFloat:0.9],
                               [NSNumber numberWithFloat:1.0], nil];
        
        maskLayer.bounds = CGRectMake(0, 0,
                                      self.postsTable.frame.size.width,
                                      self.postsTable.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        
        self.postsTable.layer.mask = maskLayer;
    }
}

-(void)additionalSetupForRecentEventForUsername:(NSString *)username andEmail:(NSString *)email {
    
    self.eventUserName = username;
    self.eventUserEmail = email;
    hasName = YES;
    
    [self submitUsernameToServer];
    [self updateVoteDictArray];
    
    [self.postsTable setAlpha:1.0];
    
    [self setBottomBarMode];
    
    [self.postsTable reloadData];
}

-(void)retrieveEvent {
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    [queryInfo setObject:self.eventInviteCode forKey:@"invitation_code"];
    
    [[NetworkAPIClient sharedClient] POST:RETRIEVE_EVENT parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *eventDict = [responseObject objectForKey:@"topic"];
        
        self.eventInviteCode = [eventDict objectForKey:@"invitation_code"];
        
        if ([responseObject objectForKey:@"invitee_name"] && [responseObject objectForKey:@"invitee_name"] != [NSNull null] && [responseObject objectForKey:@"invitee_email"] && [responseObject objectForKey:@"invitee_email"] != [NSNull null]) {
            
            [self additionalSetupForRecentEventForUsername:[responseObject objectForKey:@"invitee_name"] andEmail:[responseObject objectForKey:@"invitee_email"]];
        }
        
        if ([responseObject objectForKey:@"user_voted_state"] && [responseObject objectForKey:@"user_voted_state"] != [NSNull null]) {
            
            self.hasVoted = [[responseObject objectForKey:@"user_voted_state"] boolValue];
            
            if (self.hasVoted) [self showReVoteMode];
        }
        
        [self eventHandler:eventDict];
        [self downloadPosts];
        [self pusherConnect];
        
        [self updateVoteDictArray];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"retrieve event failed with error: %@", error);
        
        UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Error Loading Event" message:@"The invitation code supplied may have been wrong. Please try again." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            [self closeEventVC];
        }];
    }];
}

-(void)eventHandler:(NSDictionary *)eventDict {
    
    [self.eventDateTimesArray removeAllObjects];
    [self.eventDateTimesDictArray removeAllObjects];
    [self.voteDictArray removeAllObjects];
    
    self.eventTitle = [eventDict objectForKey:@"title"];
    
    self.eventConfirmed = [[eventDict objectForKey:@"confirm_state"] boolValue];
    
    if ([eventDict objectForKey:@"confirmed_date"] && [eventDict objectForKey:@"confirmed_date"] != [NSNull null]) {
        self.eventConfirmedDate = [Helpers dateFromString:[eventDict objectForKey:@"confirmed_date"]];
    }
    
    self.eventCreatorName = [eventDict objectForKey:@"creator_name"];
    self.eventCreatorEmail = [eventDict objectForKey:@"creator_email"];
    
    if ([self.eventCreatorEmail isEqualToString:self.eventUserEmail]) {
        self.isEventCreator = YES;
        [self.eventDateConfirmSetPiece setHidden:NO];
    }
    else {
        self.isEventCreator = NO;
        [self.eventDateConfirmSetPiece setHidden:YES];
    }
    
    if (self.eventConfirmed) {
        
        //hide voting
        [self.eventDateYesPiece setHidden:YES];
        [self.eventDateNoPiece setHidden:YES];
        [self.eventDateMaybePiece setHidden:YES];
        
        //hide confirmation
        [self.eventDateConfirmSetPiece setHidden:YES];
        
        [self.votingEndedAssistButton setHidden:NO];
    }
    else {
        
        [self.votingEndedAssistButton setHidden:YES];
    }
    
    //set labels
    [self setEventTitleWithTitle:[eventDict objectForKey:@"title"] place:[eventDict objectForKey:@"place_name"] andDate:nil];
    [self.lblDetailsInfo setText:[eventDict objectForKey:@"description"]];
    
    if (self.eventConfirmedDate) {
        [self setEventTitleWithTitle:[eventDict objectForKey:@"title"] place:[eventDict objectForKey:@"place_name"] andDate:self.eventConfirmedDate];
    }
    
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
    [self.eventDateTimesDictArray addObjectsFromArray:dateStringsArray];
    
    for (NSDictionary *dateDict in dateStringsArray) {
        
        NSDate *aDate = [Helpers dateFromString:[dateDict objectForKey:@"dateNtime"]];
        [self.eventDateTimesArray addObject:aDate];
    }
    
    [self.calEventDatesCalendar goToMonth:[Helpers dateFromString:[[dateStringsArray objectAtIndex:0] objectForKey:@"dateNtime"]]]; 
    
    [self updateCalendarSubviews];
    if (self.eventUserName) [self updateVoteDictArray];
    
    [self.doneDatesTableView reloadData];
    
    if (self.eventConfirmed) {
        [self scrollToDoneView];
    }
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

-(void)setVoteDot:(UIView *)voteDot withColorForDate:(NSDate *)date {
    
    for (NSDictionary *voteDict in self.voteDictArray) {
        
        NSDate *aDate = [voteDict objectForKey:@"date"];
        if ([aDate compare:date] == NSOrderedSame) {
            
            NSInteger vote = [[voteDict objectForKey:@"vote"] intValue];
            if (vote == VOTE_MAYBE) {
                [voteDot setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
            }
            else if (vote == VOTE_YES) {
                [voteDot setBackgroundColor:[Helpers softGreenColorWithAlpha:1.0]];
            }
            else if (vote == VOTE_NO) {
                [voteDot setBackgroundColor:[Helpers softRedColorWithAlpha:1.0]];
            }
        }
    }
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
            if ([self.calEventDatesCalendar date:eventDateTime isSameDayAsDate:dateKey]) {
                
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
        
        UIView *voteDot = [[UIView alloc] initWithFrame:CGRectMake(27.5, 26, 5, 5)];
        [Helpers setBorderToView:voteDot borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:voteDot.frame.size.width/2];
        [voteDot setBackgroundColor:[UIColor clearColor]];
        
        RDPieView *view = [[RDPieView alloc] initWithFrame:CGRectMake(3.5, 2.5, 30, 30)];
        [view setBackgroundColor:[UIColor clearColor]];
        [view setTag:666];
        [view setClipsToBounds:NO];
        
        [self setVoteDot:voteDot withColorForDate:dateKey];
        [view addSubview:voteDot];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[Helpers Exo2Regular:10.0]];
        
        [view addSubview:label];
        
        if (dates.count == 1) { // single cell
            
            if ([self dateHasPassed:dateKey]) {
             
                [view setAMRatio:0 setPMRatio:0];
                [view setBackgroundColor:[UIColor grayColor]];
                [view.layer setCornerRadius:view.frame.size.height/2];
                [view setClipsToBounds:YES];
                [label setTextColor:[UIColor lightGrayColor]];
            }
            else {
                
                if ([Helpers isDay:dateKey])
                    [view setAMRatio:1 setPMRatio:0];
                else
                    [view setAMRatio:0 setPMRatio:1];
            }
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"hh:mm"];
            NSString *dateString2 = [dateFormatter2 stringFromDate:dateKey];
            NSString *displayString2 = dateString2;
            [label setText:displayString2];
            [view setUserInteractionEnabled:NO];
            
        }
        else if(dates.count>1) { // multi-dates cell
            
            [voteDot setBackgroundColor:[UIColor clearColor]];
            
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
    
    [self.calEventDatesCalendar setSubviews:self.viewsForSelectedCalendarDates toDateButtonWithDate:selectedCalendarDates];
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
        
        if (!self.eventUserName) {
            
            UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Please enter a name to continue" message:@"Please enter your name to continue browsing this event." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            }];
        }
        else {
         
            //forward to dates
            [self scrollToDatesView];
            [self hideKeyboard];
        }
    }
    else if (self.mainScrollView.contentOffset.x == 320.0) {
        //forward to done
        [self submitVotesToServer];
        [self scrollToDoneView];
        [self hideKeyboard];
    }
    else if (self.mainScrollView.contentOffset.x == 640.0) {
        //close eventVC
        [self closeEventVC];
    }
}

-(void)closeEventVC {
    
    if (self.eventUserName && self.eventInviteCode)
        [self saveToRecentEvents];
 
    [self pusherDisconnect];
    
    self.postsTable = nil;
    
    [[NetworkAPIClient sharedClient] cancelHTTPOperationsWithPath:RETRIEVE_EVENT];
    [[NetworkAPIClient sharedClient] cancelHTTPOperationsWithPath:SOCAL_DOWNLOAD_POSTS];
    
    self.eventDateTimesArray = nil;
    self.eventDateTimesDictArray = nil;
    self.postsArray = nil;

    [(MainVC *)self.parentVC closeSecondView:self.view];
}

-(void)saveToRecentEvents {
    
    if (!self.eventInviteCode || !self.eventUserName || !self.eventUserEmail) {
        
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *retrievedArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"recent_events_array"];
    
    if (!retrievedArray) {
        //do nothing
    }
    else {
        [array addObjectsFromArray:retrievedArray];
    }
    
    NSMutableDictionary *recentEvent = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (popularDate) {
        [recentEvent setObject:popularDate forKey:@"popular_date"];
    }
    else {
        [self updateMostPopularDateTime];
        if (popularDate)
            [recentEvent setObject:popularDate forKey:@"popular_date"];
    }

    [recentEvent setObject:self.eventInviteCode forKey:@"invitation_code"];
    [recentEvent setObject:self.eventUserName forKey:@"username"];
    [recentEvent setObject:self.eventUserEmail forKey:@"email"];
    
    NSInteger indexExists = -1;
    
    for (NSDictionary *event in array) {
        
        if ([[event objectForKey:@"invitation_code"] isEqualToString:self.eventInviteCode]) {
            
            indexExists = [array indexOfObject:event];
        }
    }
    
    if (indexExists >= 0) {
        [array removeObjectAtIndex:indexExists];
        [array insertObject:recentEvent atIndex:indexExists];
    }
    else {
        [array addObject:recentEvent];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"recent_events_array"];
}

-(void)scrollToDatesView {
    
    [self.mainScrollView setContentOffset:CGPointMake(320.0, 0.0) animated:YES];
}

-(void)scrollToDoneView {
    
    [self.mainScrollView setContentOffset:CGPointMake(640.0, 0.0) animated:YES];
    [self.mainBackButton setHidden:YES];
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

-(IBAction)switchToCalendarOrListBtnAction {
    
    if (self.calEventDatesCalendar.hidden) {
        [self.calEventDatesCalendar setHidden:NO];
        [self.calListEventDatesTable setHidden:YES];
        [self.listCalButton setImage:[UIImage imageNamed:@"SList.png"] forState:UIControlStateNormal];
    }
    else {
        [self.calEventDatesCalendar setHidden:YES];
        [self.calListEventDatesTable setHidden:NO];
        [self.multiDayPopupDatesView setHidden:YES];
        [self.listCalButton setImage:[UIImage imageNamed:@"SCalendar.png"] forState:UIControlStateNormal];
        
        [self.calListEventDatesTable reloadData];
    }
}

#pragma mark - Bottom Bar Methods

-(void)setBottomBarMode {
    
    if (hasName) {
        [self.postsInputView setHidden:NO];
        [self.nameInputView setHidden:YES];
        [self.lblEnterNamePrompt setHidden:YES];
        
        [self.bottomBar setFrame:CGRectMake(self.bottomBar.frame.origin.x, self.bottomBar.frame.origin.y+44, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
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
    self.eventUserEmail = self.txtEmailField.text;
    hasName = YES;
    
    [self submitUsernameToServer];
    [self updateVoteDictArray];
    
    [self.postsTable setAlpha:1.0];
    
    [self setBottomBarMode];
    
    [self.postsTable reloadData];
}

#pragma mark - Username Methods

-(void)submitUsernameToServer {
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [queryInfo setObject:self.eventInviteCode forKey:@"invitation_code"];
    [queryInfo setObject:self.eventUserName forKey:@"username"];
    [queryInfo setObject:self.eventUserEmail forKey:@"email"];
    
    [[NetworkAPIClient sharedClient] POST:SOCAL_CREATE_USER parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@ has joined the conversation.", self.eventUserName);
        
        if ([responseObject objectForKey:@"user_voted_status"] && [responseObject objectForKey:@"user_voted_status"] != [NSNull null]) {
            
            self.hasVoted = [[responseObject objectForKey:@"user_voted_status"] boolValue];
            
            if (self.hasVoted) [self showReVoteMode];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)updateVoteDictArray {
    
    [self.voteDictArray removeAllObjects];
    
    for (NSDictionary *dateDict in self.eventDateTimesDictArray) {
        
        NSDate *aDate = [Helpers dateFromString:[dateDict objectForKey:@"dateNtime"]];
        NSInteger aVote = [self checkUDForPreviousVote:aDate];
        NSNumber *dateID = [dateDict objectForKey:@"id"];
        
        NSMutableDictionary *voteDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [voteDict setObject:aDate forKey:@"date"];
        
        if (aVote >= 0) [voteDict setObject:[NSNumber numberWithInt:aVote] forKey:@"vote"];
        else [voteDict setObject:[NSNumber numberWithInt:VOTE_MAYBE] forKey:@"vote"];
        
        [voteDict setObject:dateID forKey:@"id"];
        
        [self.voteDictArray addObject:voteDict];
    }
    
    [self updateCalendarSubviews];
    [self.calListEventDatesTable reloadData];
}

#pragma mark - Posts Methods

-(IBAction)btnPostAction {
    
    [self.btnPostButton setEnabled:NO];
    
    [self createPost];
}

#pragma mark - Calendar Methods

-(void)setupCalendar {
    
    [self.calEventDatesCalendar setOnlyShowCurrentMonth:NO];
    
    [self.calEventDatesCalendar setBackgroundColor:[UIColor clearColor]];
    [self.calEventDatesCalendar setInnerBorderColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    [self.calEventDatesCalendar setDayOfWeekTextColor:[UIColor whiteColor]];
    [self.calEventDatesCalendar setDateFont:[Helpers Exo2Regular:11.0]];
    [self.calEventDatesCalendar setTitleFont:[Helpers Exo2Medium:16.0]];
    [self.calEventDatesCalendar setTitleColor:[UIColor whiteColor]];
    
    [self.calEventDatesCalendar setNextButtonModifier:-30.0];
    
    [self.calEventDatesCalendar setDelegate:self];
}

#pragma mark - Pusher Methods

-(void)pusherConnect {
    
    self.pusherClient = [PTPusher pusherWithKey:[Environment Pusher_Key] delegate:self encrypted:YES];
    [self.pusherClient connect];
    [self.pusherClient setReconnectDelay:0.1];
    
    //subscribe to main channel
    NSString *channelName = [NSString stringWithFormat:@"%@_channel", self.eventInviteCode];
    [self.pusherClient subscribeToChannelNamed:channelName];
}

-(void)pusherDisconnect {
    
    [self.pusherClient disconnect];
    [self.pusherClient setDelegate:nil];
    self.pusherClient = nil;
}

#pragma mark - Pusher Delegate Methods

-(void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection {
    
}

-(void)pusher:(PTPusher *)pusher connectionDidDisconnect:(PTPusherConnection *)connection {
    
    NSLog(@"Pusher did disconnect");
}

-(void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error {
    
    NSLog(@"Pusher did disconnect with error");
}

-(void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error {
    
    NSLog(@"Pusher did fail with error");
}

-(void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel {
    
    self.eventChannel = channel;
 
    //add block handlers for pusher events
    [pusher bindToEventNamed:@"new_post" handleWithBlock:^(PTPusherEvent *channelEvent) {
        
        NSDictionary *postDict = channelEvent.data;
        [self handleNewPost:postDict];
    }];
    
    [pusher bindToEventNamed:@"broadcast_event" handleWithBlock:^(PTPusherEvent *channelEvent) {
        
        NSDictionary *eventDict = channelEvent.data;
        
        [self eventHandler:eventDict];
    }];
}

-(void)pusher:(PTPusher *)pusher didUnsubscribeFromChannel:(PTPusherChannel *)channel {
    
    NSLog(@"Unsubscribed from channel");
}

-(void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error {
    
    NSLog(@"Pusher did fail to subscribe to channel");
}

#pragma mark - Posts Methods

-(void)downloadPosts {
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [queryInfo setObject:self.eventInviteCode forKey:@"invitation_code"];
    
    [[NetworkAPIClient sharedClient] POST:SOCAL_DOWNLOAD_POSTS parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.postsArray removeAllObjects];
        
        NSArray *posts = [responseObject objectForKey:@"posts"];
        
        [self.postsArray addObjectsFromArray:posts];
        
        [self.postsTable reloadData];
        
        if (self.postsArray.count > 0 && self.postsTable)
            [self.postsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.postsArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        if (hasName) {
            
            [self.postsTable setAlpha:1.0];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)handleNewPost:(NSDictionary *)newPost {
    
    [self.postsArray addObject:newPost];
    [self.postsTable reloadData];
    
    [self.postsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.postsArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)createPost {
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [queryInfo setObject:self.eventUserEmail forKey:@"email"];
    [queryInfo setObject:self.eventInviteCode forKey:@"invitation_code"];
    [queryInfo setObject:self.txtPostField.text forKey:@"content"];
    
    [[NetworkAPIClient sharedClient] POST:SOCAL_CREATE_POST parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.txtPostField setText:@""];
        [self hideKeyboard];
        
        [self.btnPostButton setEnabled:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.btnPostButton setEnabled:YES];
    }];
}

#pragma mark - Drag Yes/No/Maybe Methods

-(void)showReVoteMode {
    
    [self.eventDateYesPiece setHidden:YES];
    [self.eventDateNoPiece setHidden:YES];
    [self.eventDateMaybePiece setHidden:YES];
    [self.eventDateRevotePiece setHidden:NO];
    
    [self.lblEventDateInstruction setText:@"You have voted previously"];
}

-(void)showNormalMode {
    
    [self.eventDateYesPiece setHidden:NO];
    [self.eventDateNoPiece setHidden:NO];
    [self.eventDateMaybePiece setHidden:NO];
    [self.eventDateRevotePiece setHidden:YES];
    
    [self.lblEventDateInstruction setText:@"Drag the buttons to the relevant dates"];
}

-(IBAction)revoteButtonAction {
    
    [self showNormalMode];
}

-(BOOL)dateHasPassed:(NSDate *)date {
    
    if ([date compare:[NSDate date]] == NSOrderedAscending) {
        
        NSLog(@"Date has passed");
        
        return YES;
    }
    
    return NO;
}

-(void)initTouchForVoteButtons {
    
    yesPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.eventDateYesPiece addGestureRecognizer:yesPan];
    noPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.eventDateNoPiece addGestureRecognizer:noPan];
    maybePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.eventDateMaybePiece addGestureRecognizer:maybePan];
    confirmSetPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleConfirmSetPan:)];
    [self.eventDateConfirmSetPiece addGestureRecognizer:confirmSetPan];
}

-(void)handleConfirmSetPan:(UIPanGestureRecognizer *)gesture {
    
    CGPoint touchLocation = [gesture locationInView:self.doneView];

    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self switchVoteButton:gesture.view toMode:VOTE_BUTTON_MOTION];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        self.eventDateConfirmSetPiece.center = touchLocation;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [self switchVoteButton:gesture.view toMode:VOTE_BUTTON_STILL];
        
        touchLocation = [gesture locationInView:self.doneDatesTableView];
        
        for (int i = 0; i < self.eventDateTimesArray.count; i++) {
            
            CGRect cellFrame = [self.doneDatesTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (CGRectContainsPoint(cellFrame, touchLocation)) {
                //confirm date target
                
                NSDate *date = [self.eventDateTimesArray objectAtIndex:i];
                
                NSString *monthStr = @"";
                NSString *timeStr = @"";
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                
                [df setAMSymbol:@"am"];
                [df setPMSymbol:@"pm"];
                
                [df setDateFormat:@"dd MMMM"];
                
                monthStr = [NSString stringWithFormat:@"%@",
                            [df stringFromDate:date]];
                
                [df setDateFormat:@"hh:mm a"];
                
                timeStr = [NSString stringWithFormat:@"%@",
                           [df stringFromDate:date]];
                
                NSString *dateStr = [NSString stringWithFormat:@"%@ on %@", timeStr, monthStr];
                
                UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Would You Like to Confirm this Event?" message:[NSString stringWithFormat:@"Would you like to confirm this event for %@?", dateStr] cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
                    if (!didCancel) {
                        [self confirmDateWithServer:date];
                    }
                }];
            }
        }
    }
}

-(void)handlePan:(UIPanGestureRecognizer *)gesture {
    
    if (self.calListEventDatesTable.hidden) {
    
        CGPoint touchLocation = [gesture locationInView:self.datesView];
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            
            [self switchVoteButton:gesture.view toMode:VOTE_BUTTON_MOTION];
        }
        else if (gesture.state == UIGestureRecognizerStateChanged) {
            
            if (gesture == yesPan) {
                
                self.eventDateYesPiece.center = touchLocation;
            }
            else if (gesture == noPan) {
                
                self.eventDateNoPiece.center = touchLocation;
            }
            else if (gesture == maybePan) {
                
                self.eventDateMaybePiece.center = touchLocation;
            }
            
            [self checkHoverMultiDate:gesture];
        }
        else if (gesture.state == UIGestureRecognizerStateEnded) {
            
            [self switchVoteButton:gesture.view toMode:VOTE_BUTTON_STILL];
            [self checkVoteButtonsTarget:gesture];
        }
    }
    else {
        
        CGPoint touchLocation = [gesture locationInView:self.datesView];
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            
            [self switchVoteButton:gesture.view toMode:VOTE_BUTTON_MOTION];
        }
        else if (gesture.state == UIGestureRecognizerStateChanged) {
            
            if (gesture == yesPan) {
                
                self.eventDateYesPiece.center = touchLocation;
            }
            else if (gesture == noPan) {
                
                self.eventDateNoPiece.center = touchLocation;
            }
            else if (gesture == maybePan) {
                
                self.eventDateMaybePiece.center = touchLocation;
            }
        }
        else if (gesture.state == UIGestureRecognizerStateEnded) {
            
            [self switchVoteButton:gesture.view toMode:VOTE_BUTTON_STILL];
            [self checkVoteButtonsTarget:gesture];
        }
    }
}

-(void)confirmDateWithServer:(NSDate *)date {
    
    NSNumber *dateID;
    
    for (NSDate *aDate in self.eventDateTimesArray) {
        
        if ([aDate compare:date] == NSOrderedSame) {
            
            dateID = [[self.eventDateTimesDictArray objectAtIndex:[self.eventDateTimesArray indexOfObject:aDate]] objectForKey:@"id"];
        }
    }
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [queryInfo setObject:self.eventInviteCode forKey:@"invitation_code"];
    [queryInfo setObject:[NSNumber numberWithBool:YES] forKey:@"confirm_state"];
    [queryInfo setObject:dateID forKey:@"confirmed_date_id"];
    
    [[NetworkAPIClient sharedClient] POST:SOCAL_CONFIRM_EVENT parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"topic confirmed");
        self.eventConfirmed = YES;
        self.eventConfirmedDate = date;
        
        [self.doneDatesTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

-(void)switchVoteButton:(id)button toMode:(NSInteger)mode {
    
    if (button == self.eventDateYesPiece) {
        
        if (mode == VOTE_BUTTON_MOTION) {
            
//            UIColor *color = self.eventDateYesPiece.backgroundColor;
//            [self.eventDateYesPiece setBackgroundColor:[UIColor clearColor]];
//            [self.eventDateYesPiece.layer setBorderColor:color.CGColor];
//            [self.eventDateYesPiece.layer setBorderWidth:1.0];
//            [self.eventDateYesPiece setTitleColor:color forState:UIControlStateNormal];
            
            CGAffineTransform t = CGAffineTransformMakeScale(1.5, 1.5);
            CGPoint center = self.eventDateYesPiece.center;
            self.eventDateYesPiece.transform = t;
            self.eventDateYesPiece.center = center;
        }
        else {
            
//            UIColor *color = [UIColor colorWithCGColor:self.eventDateYesPiece.layer.borderColor];
//            [self.eventDateYesPiece setBackgroundColor:color];
//            [self.eventDateYesPiece.layer setBorderWidth:0.0];
//            [self.eventDateYesPiece setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.eventDateYesPiece.transform = CGAffineTransformIdentity;
        }
    }
    else if (button == self.eventDateNoPiece) {
        
        if (mode == VOTE_BUTTON_MOTION) {
            
            UIColor *color = self.eventDateNoPiece.backgroundColor;
            [self.eventDateNoPiece setBackgroundColor:[UIColor clearColor]];
            [self.eventDateNoPiece.layer setBorderColor:color.CGColor];
            [self.eventDateNoPiece.layer setBorderWidth:1.0];
            [self.eventDateNoPiece setTitleColor:color forState:UIControlStateNormal];
            
            CGAffineTransform t = CGAffineTransformMakeScale(1.5, 1.5);
            CGPoint center = self.eventDateNoPiece.center;
            self.eventDateNoPiece.transform = t;
            self.eventDateNoPiece.center = center;
        }
        else {
            
            UIColor *color = [UIColor colorWithCGColor:self.eventDateNoPiece.layer.borderColor];
            [self.eventDateNoPiece setBackgroundColor:color];
            [self.eventDateNoPiece.layer setBorderWidth:0.0];
            [self.eventDateNoPiece setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.eventDateNoPiece.transform = CGAffineTransformIdentity;
        }
    }
    else if (button == self.eventDateMaybePiece) {
        
        if (mode == VOTE_BUTTON_MOTION) {
            
            UIColor *color = self.eventDateMaybePiece.backgroundColor;
            [self.eventDateMaybePiece setBackgroundColor:[UIColor clearColor]];
            [self.eventDateMaybePiece.layer setBorderColor:color.CGColor];
            [self.eventDateMaybePiece.layer setBorderWidth:1.0];
            [self.eventDateMaybePiece setTitleColor:color forState:UIControlStateNormal];
            
            CGAffineTransform t = CGAffineTransformMakeScale(1.5, 1.5);
            CGPoint center = self.eventDateMaybePiece.center;
            self.eventDateMaybePiece.transform = t;
            self.eventDateMaybePiece.center = center;
        }
        else {
            
            UIColor *color = [UIColor colorWithCGColor:self.eventDateMaybePiece.layer.borderColor];
            [self.eventDateMaybePiece setBackgroundColor:color];
            [self.eventDateMaybePiece.layer setBorderWidth:0.0];
            [self.eventDateMaybePiece setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.eventDateMaybePiece.transform = CGAffineTransformIdentity;
        }
    }
    else if (button == self.eventDateConfirmSetPiece) {
        
        if (mode == VOTE_BUTTON_MOTION) {
            
//            UIColor *color = self.eventDateConfirmSetPiece.backgroundColor;
//            [self.eventDateConfirmSetPiece setBackgroundColor:[UIColor clearColor]];
//            [self.eventDateConfirmSetPiece.layer setBorderColor:color.CGColor];
//            [self.eventDateConfirmSetPiece.layer setBorderWidth:1.0];
//            [self.eventDateConfirmSetPiece setTitleColor:color forState:UIControlStateNormal];
            
            CGAffineTransform t = CGAffineTransformMakeScale(1.5, 1.5);
            CGPoint center = self.eventDateConfirmSetPiece.center;
            self.eventDateConfirmSetPiece.transform = t;
            self.eventDateConfirmSetPiece.center = center;
        }
        else {
            
//            UIColor *color = [UIColor colorWithCGColor:self.eventDateConfirmSetPiece.layer.borderColor];
//            [self.eventDateConfirmSetPiece setBackgroundColor:color];
//            [self.eventDateConfirmSetPiece.layer setBorderWidth:0.0];
//            [self.eventDateConfirmSetPiece setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.eventDateConfirmSetPiece.transform = CGAffineTransformIdentity;
            
            //reset button position
            [UIView animateWithDuration:0.05
                             animations:^{
                                 
                                 [self.eventDateConfirmSetPiece setFrame:CGRectMake(138, 331, self.eventDateConfirmSetPiece.frame.size.width, self.eventDateConfirmSetPiece.frame.size.height)];
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    }
}

-(void)checkVoteButtonsTarget:(UIPanGestureRecognizer *)gesture {
    
    if (!self.multiDayPopupDatesView.hidden) {
        
        CGPoint releaseLocation = [gesture locationInView:self.multiDayPopupDatesView];
        
        NSDate *releasePointDate;
        
        if (CGRectContainsPoint(self.multiDayOption1.frame, releaseLocation)) {
         
            releasePointDate = [multiDatesArray objectAtIndex:0];
        }
        else if (CGRectContainsPoint(self.multiDayOption2.frame, releaseLocation)) {
            
            releasePointDate = [multiDatesArray objectAtIndex:1];
        }
        else if (CGRectContainsPoint(self.multiDayOption3.frame, releaseLocation)) {
            
            releasePointDate = [multiDatesArray objectAtIndex:2];
        }
        else if (CGRectContainsPoint(self.multiDayOption4.frame, releaseLocation)) {
            
            releasePointDate = [multiDatesArray objectAtIndex:3];
        }
        
        if ([self dateHasPassed:releasePointDate]) {
            
            NSLog(@"Add alert here for date has passed");
            return;
        }
        
        if (gesture.view == self.eventDateYesPiece) {
            
            [self vote:VOTE_YES forDate:releasePointDate];
        }
        else if (gesture.view == self.eventDateNoPiece) {
            
            [self vote:VOTE_NO forDate:releasePointDate];
        }
        else if (gesture.view == self.eventDateMaybePiece) {
            
            [self vote:VOTE_MAYBE forDate:releasePointDate];
        }
        
        [self performSelector:@selector(hideMultiDayPopupDatesView) withObject:nil afterDelay:0.25];
        
        //reset button positions
        
        [UIView animateWithDuration:0.05
                         animations:^{
                             
                             [self.eventDateYesPiece setFrame:CGRectMake(20, 269, self.eventDateYesPiece.frame.size.width, self.eventDateYesPiece.frame.size.height)];
                             [self.eventDateNoPiece setFrame:CGRectMake(72, 269, self.eventDateNoPiece.frame.size.width, self.eventDateNoPiece.frame.size.height)];
                             [self.eventDateMaybePiece setFrame:CGRectMake(124, 269, self.eventDateMaybePiece.frame.size.width, self.eventDateMaybePiece.frame.size.height)];
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        return;
    }
    
    //reset button positions
    
    [UIView animateWithDuration:0.05
                     animations:^{
                         
                         [self.eventDateYesPiece setFrame:CGRectMake(20, 269, self.eventDateYesPiece.frame.size.width, self.eventDateYesPiece.frame.size.height)];
                         [self.eventDateNoPiece setFrame:CGRectMake(72, 269, self.eventDateNoPiece.frame.size.width, self.eventDateNoPiece.frame.size.height)];
                         [self.eventDateMaybePiece setFrame:CGRectMake(124, 269, self.eventDateMaybePiece.frame.size.width, self.eventDateMaybePiece.frame.size.height)];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    NSDate *releasePointDate = nil;
    if (self.calListEventDatesTable.hidden) {
    
        CGPoint releaseLocation = [gesture locationInView:self.calEventDatesCalendar];
        releasePointDate = [self.calEventDatesCalendar dateForLocationInView:releaseLocation];
    }
    else {
    
        CGPoint releaseLocation = [gesture locationInView:self.calListEventDatesTable];
        releasePointDate = [self dateForLocationInTableView:releaseLocation];
    }
    
    NSDate *votedDate = nil;
    
    if (self.calListEventDatesTable.hidden) {
        
        int count = 0;
        
        NSMutableArray *multiDates = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (NSDate *aDate in self.eventDateTimesArray) {
            
            if ([self.calEventDatesCalendar date:releasePointDate isSameDayAsDate:aDate]) {
                
                votedDate = aDate;
                count++;
                [multiDates addObject:aDate];
            }
        }
        
        if (count > 1) {
            //multiple dates in day
            //return
            
            NSLog(@"Multiple dates in this day");
            
//            [self multiDatesInDayHandler:multiDates];
            return;
        }
        else {
            //only one date in day
            //continue
        }
    }
    else {
        
        votedDate = releasePointDate;
    }
    
    if ([self dateHasPassed:releasePointDate]) {
        
        NSLog(@"Add alert here for date has passed");
        return;
    }
    
    if (gesture.view == self.eventDateYesPiece) {
        
        [self vote:VOTE_YES forDate:votedDate];
    }
    else if (gesture.view == self.eventDateNoPiece) {
        
        [self vote:VOTE_NO forDate:votedDate];
    }
    else if (gesture.view == self.eventDateMaybePiece) {
        
        [self vote:VOTE_MAYBE forDate:votedDate];
    }
}

-(NSDate *)dateForLocationInTableView:(CGPoint)point {
    
    for (int i = 0; i < self.eventDateTimesArray.count; i++) {
    
        CGRect frame = [self.calListEventDatesTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if (CGRectContainsPoint(frame, point)) {
            
            //is voted date
            return [self.eventDateTimesArray objectAtIndex:i];
        }
    }
    
    return nil;
}

-(IBAction)noVoteForConfirmedEvent {
    
    UIBAlertView *alertView = [[UIBAlertView alloc] initWithTitle:@"Event Has Been Finalized" message:[NSString stringWithFormat:@"Sorry, but you cannot vote on an event that has already been finalized. The date has been set! If you can't make it, do get in touch with %@, the organizer.", self.eventCreatorName] cancelButtonTitle:@"Ok" otherButtonTitles:@"Email", nil];
    [alertView showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
        if (!didCancel) {
            [self emailOrganizer];
        }
    }];
}

-(void)vote:(NSInteger)vote forDate:(NSDate *)date {
    
    if (self.eventConfirmed) {
        
        [self noVoteForConfirmedEvent];
        
        return;
    }
    
    if (!date) {
        return;
    }
    
    for (NSMutableDictionary *voteDict in self.voteDictArray) {
        
        NSDate *aDate = [voteDict objectForKey:@"date"];
        
        if ([aDate compare:date] == NSOrderedSame) {
            
            [voteDict setObject:[NSNumber numberWithInt:vote] forKey:@"vote"];
        }
    }
    
    if (!self.calEventDatesCalendar.hidden) {
        
        for (NSDate *aDate in multiDatesArray) {
            
            if ([aDate compare:date] == NSOrderedSame) {
                
                CGRect frame = CGRectMake(0, 0, 0, 0);
                
                if ([multiDatesArray indexOfObject:aDate] == 0) {
                    frame = self.multiDayOption1.frame;
                }
                else if ([multiDatesArray indexOfObject:aDate] == 1) {
                    frame = self.multiDayOption2.frame;
                }
                else if ([multiDatesArray indexOfObject:aDate] == 2) {
                    frame = self.multiDayOption3.frame;
                }
                else if ([multiDatesArray indexOfObject:aDate] == 3) {
                    frame = self.multiDayOption4.frame;
                }
                
                [self flashSelection:frame inView:self.multiDayPopupDatesView];
                
                return;
            }
        }
        
        CGRect frame = [self.calEventDatesCalendar frameForDate:date];
        [self flashSelection:frame inView:self.calEventDatesCalendar];
    }
    else if (!self.calListEventDatesTable.hidden) {
        
        NSInteger row = 0;
        
        for (NSDate *aDate in self.eventDateTimesArray) {
            
            if ([aDate compare:date] == NSOrderedSame) {
                
                row = [self.eventDateTimesArray indexOfObject:aDate];
            }
        }
        
        ListDateTimeCell *cell = (ListDateTimeCell *)[self.calListEventDatesTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        CGRect frame = [cell convertRect:cell.mainBGView.frame toView:self.calListEventDatesTable];
        
        [self flashSelection:frame inView:self.calListEventDatesTable];
    }
    
    [self updateCalendarSubviews];
    [self.calListEventDatesTable reloadData];
}

-(void)flashSelection:(CGRect)frame inView:(UIView *)parentView {
    
    UIView *dateView = [[UIView alloc] initWithFrame:frame];
    [dateView setBackgroundColor:[UIColor darkGrayColor]];
    [dateView setAlpha:0.0];
    
    if (parentView == self.calEventDatesCalendar) {
        
        [parentView addSubview:dateView];
    }
    else if (parentView == self.multiDayPopupDatesView) {
        
        [parentView addSubview:dateView];
    }
    else if (parentView == self.calListEventDatesTable) {
        
        [parentView addSubview:dateView];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        
        [dateView setAlpha:0.5];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            [dateView setAlpha:0.0];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                [dateView setAlpha:0.5];
                
            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    [dateView setAlpha:0.0];
                    
                } completion:^(BOOL finished) {
                    
                    [dateView removeFromSuperview];
                    
                }];
                
            }];
            
        }];
        
    }];
}

-(void)submitVotesToServer {
    
    if (self.hasVoted && !self.eventDateRevotePiece.hidden) {
        
        return;
    }
    
    NSString *paramsDatesVotes = @"";
    
    for (NSMutableDictionary *voteDict in self.voteDictArray) {
        
        NSDate *aDate = [voteDict objectForKey:@"date"];
        NSInteger possibleVote = [[voteDict objectForKey:@"vote"] integerValue];
        
        NSNumber *dateID;
        
        for (NSDate *date in self.eventDateTimesArray) {
            
            if ([aDate compare:date] == NSOrderedSame) {
                
                dateID = [[self.eventDateTimesDictArray objectAtIndex:[self.eventDateTimesArray indexOfObject:aDate]] objectForKey:@"id"];
            }
        }
        
        paramsDatesVotes = [paramsDatesVotes stringByAppendingString:[NSString stringWithFormat:@"%@", dateID]];
        paramsDatesVotes = [paramsDatesVotes stringByAppendingString:@","];
        paramsDatesVotes = [paramsDatesVotes stringByAppendingString:[NSString stringWithFormat:@"%li", (long)possibleVote]];
        paramsDatesVotes = [paramsDatesVotes stringByAppendingString:@"{"];
    }
    
    NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [queryInfo setObject:paramsDatesVotes forKey:@"votes"];
    [queryInfo setObject:self.eventUserEmail forKey:@"email"];
    [queryInfo setObject:self.eventInviteCode forKey:@"invitation_code"];
    
    [[NetworkAPIClient sharedClient] POST:VOTE_FOR_DATE parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSMutableDictionary *voteDict in self.voteDictArray) {
         
            NSDate *aDate = [voteDict objectForKey:@"date"];
            NSInteger possibleVote = [[voteDict objectForKey:@"vote"] integerValue];
            [self saveVoteToUD:aDate andVote:possibleVote];
        }
        
        [self retrieveEvent];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.mainDoneButton setEnabled:YES];
    }];
}

-(NSInteger)checkUDForPreviousVote:(NSDate *)date {
    
    NSString *key = [NSString stringWithFormat:@"%@_%@_votes", self.eventInviteCode, self.eventUserName];
    
    NSMutableArray *arrayOfVoteDicts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
    
    if (arrayOfVoteDicts) {
     
        for (NSDictionary *voteDict in arrayOfVoteDicts) {
            
            NSDate *aDate = [voteDict objectForKey:@"date"];
            if ([aDate compare:date] == NSOrderedSame) {
                return [[voteDict objectForKey:@"vote"] intValue];
            }
        }
    }
    
    return -1;
}

-(void)saveVoteToUD:(NSDate *)date andVote:(int)vote {
    
    NSMutableDictionary *voteDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [voteDict setObject:date forKey:@"date"];
    [voteDict setObject:[NSNumber numberWithInt:vote] forKey:@"vote"];
    
    NSString *key = [NSString stringWithFormat:@"%@_%@_votes", self.eventInviteCode, self.eventUserName];
    
    NSMutableArray *arrayOfVoteDicts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
    
    if (arrayOfVoteDicts) {
        
        [arrayOfVoteDicts addObject:voteDict];
    }
    else {
        
        arrayOfVoteDicts = [[NSMutableArray alloc] initWithCapacity:0];
        [arrayOfVoteDicts addObject:voteDict];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:arrayOfVoteDicts forKey:key];
}

-(void)updateMostPopularDateTime {
    
    if (self.eventConfirmed) {
        
        NSDate *date = self.eventConfirmedDate;
        
        NSString *monthStr = @"";
        NSString *timeStr = @"";
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setAMSymbol:@"am"];
        [df setPMSymbol:@"pm"];
        
        [df setDateFormat:@"dd MMMM"];
        
        monthStr = [NSString stringWithFormat:@"%@",
                    [df stringFromDate:date]];
        
        [df setDateFormat:@"hh:mm a"];
        
        timeStr = [NSString stringWithFormat:@"%@",
                   [df stringFromDate:date]];
        
        NSString *str = [NSString stringWithFormat:@"%@ on %@ is the confirmed date and time for the event.", timeStr, monthStr];
        
        [self.lblDoneSummaryLabel setText:str];
        [self setSummaryLabelWithAttributedStringForTime:timeStr andMonth:monthStr];
        
        return;
    }
    else {
        
        NSMutableDictionary *queryInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        [queryInfo setObject:self.eventInviteCode forKey:@"invitation_code"];
        
        [[NetworkAPIClient sharedClient] POST:RETRIEVE_POPULAR_DATE parameters:queryInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([responseObject objectForKey:@"popular_date"] && [responseObject objectForKey:@"popular_date"] != [NSNull null]) {
                
                NSDictionary *dateDict = [responseObject objectForKey:@"popular_date"];
                
                NSDate *date;
                
                if ([dateDict objectForKey:@"date"] && [dateDict objectForKey:@"date"] != [NSNull null]) {
                    
                    date = [Helpers dateFromString:[dateDict objectForKey:@"date"]];
                    
                    NSString *monthStr = @"";
                    NSString *timeStr = @"";
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    
                    [df setAMSymbol:@"am"];
                    [df setPMSymbol:@"pm"];
                    
                    [df setDateFormat:@"dd MMMM"];
                    
                    monthStr = [NSString stringWithFormat:@"%@",
                                [df stringFromDate:date]];
                    
                    [df setDateFormat:@"hh:mm a"];
                    
                    timeStr = [NSString stringWithFormat:@"%@",
                               [df stringFromDate:date]];
                    
                    NSString *str = [NSString stringWithFormat:@"%@ on %@ is currently the most popular date and time.", timeStr, monthStr];
                    
                    [self.lblDoneSummaryLabel setText:str];
                    [self setSummaryLabelWithAttributedStringForTime:timeStr andMonth:monthStr];
                    
                    popularDate = date;
                }
                else {
                    
                    popularDate = nil;
                    
                    NSString *str = @"Insufficient data to calculate the most popular event date at the moment.";
                    [self.lblDoneSummaryLabel setText:str];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            popularDate = nil;
            
            NSString *str = @"Insufficient data to calculate the most popular event date at the moment.";
            [self.lblDoneSummaryLabel setText:str];
            
            return;
        }];
    }
}

-(void)setSummaryLabelWithAttributedStringForTime:(NSString *)timeStr andMonth:(NSString *)monthStr {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.lblDoneSummaryLabel.text];
    
    [string addAttribute:NSFontAttributeName value:[Helpers Exo2MediumItalic:14.0] range:NSMakeRange(0, timeStr.length)];
    [string addAttribute:NSFontAttributeName value:[Helpers Exo2MediumItalic:14.0] range:NSMakeRange(timeStr.length + 4, monthStr.length)];
    
    [self.lblDoneSummaryLabel setAttributedText:string];
}

-(void)checkHoverMultiDate:(UIPanGestureRecognizer *)gesture {
    
    NSDate *hoverPointDate = nil;
        
    CGPoint hoverLocation = [gesture locationInView:self.calEventDatesCalendar];
    hoverPointDate = [self.calEventDatesCalendar dateForLocationInView:hoverLocation];
    
    int count = 0;
    
    NSMutableArray *multiDates = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDate *aDate in self.eventDateTimesArray) {
        
        if ([self.calEventDatesCalendar date:hoverPointDate isSameDayAsDate:aDate]) {
            
            count++;
            [multiDates addObject:aDate];
        }
    }
    
    if (count > 1) {
        //multiple dates in day
        //return
        
        NSLog(@"Multiple dates in this day");
        
        NSLog(@"touch point in cal: %f, %f", hoverLocation.x, hoverLocation.y);
        
        CGPoint touchPoint = [gesture locationInView:self.datesView];
        
        [self multiDatesInDayHandler:multiDates andTouchPoint:touchPoint];
        return;
    }
    else {
        //only one date in day
        //continue
    }
}

-(void)multiDatesInDayHandler:(NSArray *)datesArray andTouchPoint:(CGPoint)touchPoint {
    
    multiDatesArray = datesArray;
    
    if (self.multiDayPopupDatesView.hidden) {
    
        NSLog(@"show frame");
        
        CGFloat originX = 0.0;
        CGFloat originY = 0.0;
        
        if (touchPoint.x >= 160.0) {
            originX = touchPoint.x - 120.0;
        }
        else {
            originX = touchPoint.x + 20.0;
        }
        
        if (touchPoint.y >= self.calEventDatesCalendar.frame.size.height/2) {
            originY = touchPoint.y - 120.0;
        }
        else {
            originY = touchPoint.y - 60.0;
        }
        
        [self.multiDayPopupDatesView setFrame:CGRectMake(originX, originY, self.multiDayPopupDatesView.frame.size.width, self.multiDayPopupDatesView.frame.size.height)];
        
        NSLog(@"touch point: %f, %f", touchPoint.x, touchPoint.y);
        NSLog(@"origin of popup view: %f, %f", originX, originY);
        
        [self.multiDayOption1 setText:@""];
        [self.multiDayOption1 setBackgroundColor:[UIColor clearColor]];
        [self.multiDayOption2 setText:@""];
        [self.multiDayOption2 setBackgroundColor:[UIColor clearColor]];
        [self.multiDayOption3 setText:@""];
        [self.multiDayOption3 setBackgroundColor:[UIColor clearColor]];
        [self.multiDayOption4 setText:@""];
        [self.multiDayOption4 setBackgroundColor:[UIColor clearColor]];
        
        [self.multiDayOption1VoteDot setBackgroundColor:[UIColor clearColor]];
        [self.multiDayOption2VoteDot setBackgroundColor:[UIColor clearColor]];
        [self.multiDayOption3VoteDot setBackgroundColor:[UIColor clearColor]];
        [self.multiDayOption4VoteDot setBackgroundColor:[UIColor clearColor]];
        
        [Helpers setBorderToView:self.multiDayOption1VoteDot borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:self.multiDayOption1VoteDot.frame.size.width/2];
        [Helpers setBorderToView:self.multiDayOption2VoteDot borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:self.multiDayOption2VoteDot.frame.size.width/2];
        [Helpers setBorderToView:self.multiDayOption3VoteDot borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:self.multiDayOption3VoteDot.frame.size.width/2];
        [Helpers setBorderToView:self.multiDayOption4VoteDot borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:self.multiDayOption4VoteDot.frame.size.width/2];
        
        for (int i = 0; i < datesArray.count; i++) {
            
            NSDate *aDate = [datesArray objectAtIndex:i];
            
            NSString *timeStr = @"";
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            
            [df setAMSymbol:@"am"];
            [df setPMSymbol:@"pm"];
            
            [df setDateFormat:@"dd MMMM"];
            
            [df setDateFormat:@"hh:mm a"];
            
            timeStr = [NSString stringWithFormat:@"%@",
                       [df stringFromDate:aDate]];
            
            if (i == 0) {
                
                [self.multiDayOption1 setText:timeStr];
                
                if ([timeStr hasSuffix:@"am"]) {
                    [self.multiDayOption1 setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
                }
                else {
                    [self.multiDayOption1 setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
                }
                
                [self setVoteDot:self.multiDayOption1VoteDot withColorForDate:aDate];
                [Helpers setBorderToView:self.multiDayOption1VoteDot borderColor:[UIColor whiteColor] borderThickness:0.3 borderRadius:self.multiDayOption1VoteDot.frame.size.width/2];
            }
            else if (i == 1) {
                
                [self.multiDayOption2 setText:timeStr];
                
                if ([timeStr hasSuffix:@"am"]) {
                    [self.multiDayOption2 setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
                }
                else {
                    [self.multiDayOption2 setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
                }
                
                [self setVoteDot:self.multiDayOption2VoteDot withColorForDate:aDate];
                [Helpers setBorderToView:self.multiDayOption2VoteDot borderColor:[UIColor whiteColor] borderThickness:0.3 borderRadius:self.multiDayOption1VoteDot.frame.size.width/2];
            }
            else if (i == 2) {
                
                [self.multiDayOption3 setText:timeStr];
                
                if ([timeStr hasSuffix:@"am"]) {
                    [self.multiDayOption3 setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
                }
                else {
                    [self.multiDayOption3 setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
                }
                
                [self setVoteDot:self.multiDayOption3VoteDot withColorForDate:aDate];
                [Helpers setBorderToView:self.multiDayOption3VoteDot borderColor:[UIColor whiteColor] borderThickness:0.3 borderRadius:self.multiDayOption1VoteDot.frame.size.width/2];
            }
            else if (i == 3) {
                
                [self.multiDayOption4 setText:timeStr];
                
                if ([timeStr hasSuffix:@"am"]) {
                    [self.multiDayOption4 setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
                }
                else {
                    [self.multiDayOption4 setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
                }
                
                [self setVoteDot:self.multiDayOption4VoteDot withColorForDate:aDate];
                [Helpers setBorderToView:self.multiDayOption4VoteDot borderColor:[UIColor whiteColor] borderThickness:0.3 borderRadius:self.multiDayOption1VoteDot.frame.size.width/2];
            }
        }
        
        [self.multiDayPopupDatesView setAlpha:0.0];
        [self.multiDayPopupDatesView setHidden:NO];
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.multiDayPopupDatesView setAlpha:1.0];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)hideMultiDayPopupDatesView {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.multiDayPopupDatesView setAlpha:0.0];
        
    } completion:^(BOOL finished) {
    
        [self.multiDayPopupDatesView setHidden:YES];
        [self.multiDayPopupDatesView setAlpha:1.0];
    }];
}

-(void)emailOrganizer {
    
    if (![MFMailComposeViewController canSendMail]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You device is not set up for email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDate *date = self.eventConfirmedDate;
    
    NSString *monthStr = @"";
    NSString *timeStr = @"";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setAMSymbol:@"am"];
    [df setPMSymbol:@"pm"];
    
    [df setDateFormat:@"dd MMMM"];
    
    monthStr = [NSString stringWithFormat:@"%@",
                [df stringFromDate:date]];
    
    [df setDateFormat:@"hh:mm a"];
    
    timeStr = [NSString stringWithFormat:@"%@",
               [df stringFromDate:date]];
    
    NSString *str = [NSString stringWithFormat:@"%@ on %@", timeStr, monthStr];
    
    MFMailComposeViewController *mailcompose = [[MFMailComposeViewController alloc] init];
    
    NSString *messageBody = [NSString stringWithFormat:@"<html><p>Hi %@,</p><p>Unfortunately, I'm no longer able to vote for my preferred dates for %@. I don't think I can make it at %@. I'll join you guys next time!</p><p>Regards,<br/>%@</p></html>", self.eventCreatorName, self.eventTitle, str, self.eventUserName];
    
    mailcompose = [[MFMailComposeViewController alloc] init];
    mailcompose.mailComposeDelegate = self;
    [mailcompose setSubject:@"Sorry, I may not be able to attend the event"];
    [mailcompose setMessageBody:messageBody isHTML:YES];
    NSArray *array = [NSArray arrayWithObject:self.eventCreatorEmail];
    [mailcompose setToRecipients:array];
    
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
    
    [controller dismissViewControllerAnimated:NO completion:^{
        //remain at done view
        [self scrollToDoneView];
    }];
}

#pragma mark - CKCalendarView Delegate Methods

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    int count = 0;
    
    NSMutableArray *multiDates = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDate *aDate in self.eventDateTimesArray) {
        
        if ([self.calEventDatesCalendar date:date isSameDayAsDate:aDate]) {
            
            count++;
            [multiDates addObject:aDate];
        }
    }
    
    if (count > 1) {
        //multiple dates in day
        //return
        
        NSLog(@"Multiple dates in this day");
        
        if (self.multiDayPopupDatesView.hidden) {
            CGPoint touchPoint = [calendar centerPointForDate:date];
            
            if (touchPoint.x == 0.0 && touchPoint.y == 0.0) {
                
            }
            else {
                touchPoint = CGPointMake(touchPoint.x+20, touchPoint.y);
                [self multiDatesInDayHandler:multiDates andTouchPoint:touchPoint];
                
                NSLog(@"touch point in cal: %f, %f", touchPoint.x, touchPoint.y);
            }
        }
        else {
            [self hideMultiDayPopupDatesView];
        }
        
        return;
    }
    else {
        //only one date in day
        //continue
        
        CGPoint touchPoint = [calendar centerPointForDate:date];
        NSLog(@"touch point in cal: %f, %f", touchPoint.x, touchPoint.y);
    }
}

-(void)calendar:(CKCalendarView *)calendar didChangeToMonth:(NSDate *)date {
    
    [self hideMultiDayPopupDatesView];
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainScrollView) {
        
        [(MainVC *)self.parentVC scrollBGViewToOffset:CGPointMake(scrollView.contentOffset.x+320, 0)];
        
        [self.postsTable setHidden:NO];
        [self.bottomBar setHidden:NO];
        
//        [self.postsTable setFrame:CGRectMake(self.postsTable.frame.origin.x, 314, self.postsTable.frame.size.width, 210)];
        
        if (scrollView.contentOffset.x == 0.0) {
            [[(MainVC *)self.parentVC mainScrollView] setScrollEnabled:YES];
        }
        else {
            [[(MainVC *)self.parentVC mainScrollView] setScrollEnabled:NO];
        }
        
        if (scrollView.contentOffset.x < 320.0) {
            
            [self.mainBackButton setTitle:@"Home" forState:UIControlStateNormal];
            [self.mainDoneButton setTitle:@"Dates" forState:UIControlStateNormal];
            [self.lblTitleLabel setText:@"Details"];
        }
        else if (scrollView.contentOffset.x < 640.0) {
            
            [self.mainBackButton setTitle:@"Details" forState:UIControlStateNormal];
            [self.mainDoneButton setTitle:@"Done" forState:UIControlStateNormal];
            [self.lblTitleLabel setText:@"Dates"];
            
//            [self.postsTable setFrame:CGRectMake(self.postsTable.frame.origin.x, 377, self.postsTable.frame.size.width, 210-(377-314))];
        }
        else if (scrollView.contentOffset.x < 920.0) {
            
            if (scrollView.contentOffset.x == 640.0) {
                
                [self updateMostPopularDateTime];
                [self.doneDatesTableView reloadData];
            }
            
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
    else if (scrollView == self.postsTable) {
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
        [CATransaction commit];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainScrollView) {
        
        float modifier = 0.0;
        if ([Helpers iPhone4]) {
            modifier = -88.0;
        }
        
        if (scrollView.contentOffset.x == 0.0) {
            
            [self.postsTable setFrame:CGRectMake(self.postsTable.frame.origin.x, 314, self.postsTable.frame.size.width, 210 + modifier)];
            maskLayer.bounds = CGRectMake(0, 0,
                                          self.postsTable.frame.size.width,
                                          self.postsTable.frame.size.height);
            maskLayer.anchorPoint = CGPointZero;
        }
        else if (scrollView.contentOffset.x == 320.0) {
            
            [self.postsTable setFrame:CGRectMake(self.postsTable.frame.origin.x, 377, self.postsTable.frame.size.width, 210-(377-314) + modifier)];
            maskLayer.bounds = CGRectMake(0, 0,
                                          self.postsTable.frame.size.width,
                                          self.postsTable.frame.size.height);
            maskLayer.anchorPoint = CGPointZero;
            
            if (self.postsArray.count > 0)
                [self.postsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.postsArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        else if (scrollView.contentOffset.x == 640.0) {
            
        }
    }
    
    NSLog(@"%@", self.postsTable);
}

#pragma mark - UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.postsTable)
        return self.postsArray.count;
    else
        return self.eventDateTimesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.postsTable) {
        
        PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:@"PostCell"];
        
        if (!cell) {
            cell = [PostCell newPostCell];
        }
        
        NSDictionary *postDict = [self.postsArray objectAtIndex:indexPath.row];
        
        [cell.contentLabel setText:[postDict objectForKey:@"content"]];
        
        if ([cell.contentLabel.text hasSuffix:@"has joined the conversation"]) {
            [cell.authorLabel setText:@""];
        }
        else {
            [cell.authorLabel setText:[postDict objectForKey:@"username"]];
        }
        
        [cell.timeLabel setText:[Helpers timeframeFromString:[postDict objectForKey:@"created_at"]]];
        
        if ([cell.authorLabel.text isEqualToString:self.eventUserName]) {
            [cell setRightSide];
        }
        else {
            [cell setLeftSide];
        }
        
        return cell;
    }
    else if (tableView == self.calListEventDatesTable) {
        
        ListDateTimeCell *cell = (ListDateTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"ListDateTimeCelll"];
        
        if (!cell) {
            cell = [ListDateTimeCell newCell];
        }
        
        NSInteger vote = VOTE_MAYBE;
        
        if (self.voteDictArray.count > 0) {
            NSDictionary *voteDict = [self.voteDictArray objectAtIndex:indexPath.row];
            vote = [[voteDict objectForKey:@"vote"] intValue];
        }
        
        [cell renderWithDate:[self.eventDateTimesArray objectAtIndex:indexPath.row] andVote:vote];
        
        return cell;
    }
    else { //doneDatesTableView
        
        SummaryDateTimeCell *cell = (SummaryDateTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"SummaryDateTimeCell"];
        
        if (!cell) {
            cell = [SummaryDateTimeCell newCell];
        }

        NSDate *date = [self.eventDateTimesArray objectAtIndex:indexPath.row];
        NSDictionary *dateTimeDict = [self.eventDateTimesDictArray objectAtIndex:indexPath.row];
        
        int maybe = [[dateTimeDict objectForKey:@"maybe"] intValue];
        int no = [[dateTimeDict objectForKey:@"no"] intValue];
        int yes = [[dateTimeDict objectForKey:@"yes"] intValue];
        
        [cell renderWithDate:date andVotesYes:yes no:no Maybe:maybe];
        
        [cell.starLabel setHidden:YES];
        
        if (popularDate) {
            if ([date compare:popularDate] == NSOrderedSame) {
                [cell.starLabel setHidden:NO];
            }
        }
        
        if (self.eventConfirmed && self.eventConfirmedDate) {
            
            if ([self.eventConfirmedDate compare:date] == NSOrderedSame) {
                [cell.starLabel setHidden:NO];
                [cell.starLabel setTextColor:[UIColor yellowColor]];
            }
        }
        else {
            [cell.starLabel setTextColor:[UIColor whiteColor]];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.postsTable) {
        return 65.0;
    }
    else {
        return 50.0;
    }
}

#pragma mark - Keyboard Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.txtNameField) {
        
        [self btnNameOkAction];
    }
    else if (textField == self.txtPostField) {
        
        [self btnPostAction];
    }
    
    return YES;
}

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
    
    originalPostsTableOriginY = self.postsTable.frame.origin.y;
    originalPostsTableHeight = self.postsTable.frame.size.height;
    
    if (self.nameInputView.hidden) {
        [self.bottomBar setFrame:CGRectMake(0, self.view.frame.size.height - self.bottomBar.frame.size.height - 172, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
        [self.lblEnterNamePrompt setFrame:CGRectMake(self.lblEnterNamePrompt.frame.origin.x, self.bottomBar.frame.origin.y - self.lblEnterNamePrompt.frame.size.height, self.lblEnterNamePrompt.frame.size.width, self.lblEnterNamePrompt.frame.size.height)];
        
        [self.postsTable setFrame:CGRectMake(0, 64, self.postsTable.frame.size.width, self.bottomBar.frame.origin.y-64)];
    }
    else {
        [self.bottomBar setFrame:CGRectMake(0, self.view.frame.size.height - self.bottomBar.frame.size.height - 216, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
        [self.lblEnterNamePrompt setFrame:CGRectMake(self.lblEnterNamePrompt.frame.origin.x, self.bottomBar.frame.origin.y - self.lblEnterNamePrompt.frame.size.height, self.lblEnterNamePrompt.frame.size.width, self.lblEnterNamePrompt.frame.size.height)];
        
        [self.postsTable setFrame:CGRectMake(0, 64, self.postsTable.frame.size.width, self.bottomBar.frame.origin.y-64)];
    }
    
    maskLayer.bounds = CGRectMake(0, 0,
                                  self.postsTable.frame.size.width,
                                  self.postsTable.frame.size.height);
    maskLayer.anchorPoint = CGPointZero;
    [self.postsTable setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    
    [self.view removeGestureRecognizer:downSwipe];
    [self.view removeGestureRecognizer:tapGesture];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    if (self.nameInputView.hidden) {
        [self.bottomBar setFrame:CGRectMake(0, self.view.frame.size.height - self.bottomBar.frame.size.height + 44, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
        [self.lblEnterNamePrompt setFrame:CGRectMake(self.lblEnterNamePrompt.frame.origin.x, self.bottomBar.frame.origin.y - self.lblEnterNamePrompt.frame.size.height, self.lblEnterNamePrompt.frame.size.width, self.lblEnterNamePrompt.frame.size.height)];
        
        [self.postsTable setFrame:CGRectMake(0, originalPostsTableOriginY, self.postsTable.frame.size.width, originalPostsTableHeight)];
    }
    else {
        [self.bottomBar setFrame:CGRectMake(0, self.view.frame.size.height - self.bottomBar.frame.size.height, self.bottomBar.frame.size.width, self.bottomBar.frame.size.height)];
        [self.lblEnterNamePrompt setFrame:CGRectMake(self.lblEnterNamePrompt.frame.origin.x, self.bottomBar.frame.origin.y - self.lblEnterNamePrompt.frame.size.height, self.lblEnterNamePrompt.frame.size.width, self.lblEnterNamePrompt.frame.size.height)];
        
        [self.postsTable setFrame:CGRectMake(0, originalPostsTableOriginY, self.postsTable.frame.size.width, originalPostsTableHeight)];
    }
    
    maskLayer.bounds = CGRectMake(0, 0,
                                  self.postsTable.frame.size.width,
                                  self.postsTable.frame.size.height);
    maskLayer.anchorPoint = CGPointZero;
    [self.postsTable setBackgroundColor:[UIColor clearColor]];
    
    [UIView commitAnimations];
}

-(void)hideKeyboard {
    
    [self.txtNameField resignFirstResponder];
    [self.txtEmailField resignFirstResponder];
    [self.txtPostField resignFirstResponder];
}

@end
