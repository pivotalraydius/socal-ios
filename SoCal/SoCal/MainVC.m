//
//  MainVCViewController.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "MainVC.h"
#import "AppDelegate.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+AFNetworking.h"

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    self.recentEventsArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [self retrieveRecentEvents];
    [self.inviteCodeField setText:@""];
    [self.inviteCodeField setHidden:YES];
    
    [super viewWillAppear:animated];
    
    [self becomeFirstResponder];
    
    //set sign in button status
    if ([User loggedInToRaydius]) {
        [self.btnSignInOut setTitle:@"Sign out" forState:normal];
        NSLog(@"Sign in status");
    }
    else {
        [self.btnSignInOut setTitle:@"Sign In" forState:normal];
        NSLog(@"Not sign in yet");
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self setupFonts];
    
    [self retrieveBackgroundImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)setupUI {
    
    [self.inviteCodeField setHidden:YES];

    
    [Helpers setBorderToView:self.btnCancelQRCodeScanner borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:3.0];
    
    if ([Helpers iPhone4]) {
        
        [self.btnCreateEvent setFrame:CGRectMake(self.btnCreateEvent.frame.origin.x, self.btnCreateEvent.frame.origin.y-88, self.btnCreateEvent.frame.size.width, self.btnCreateEvent.frame.size.height)];
        [self.btnUseInvite setFrame:CGRectMake(self.btnUseInvite.frame.origin.x, self.btnUseInvite.frame.origin.y-88, self.btnUseInvite.frame.size.width, self.btnUseInvite.frame.size.height)];
    }
    
    [self.recentEventsTable registerClass:[RecentEventCell class] forCellWithReuseIdentifier:@"RECENT_EVENT_CELL"];
    
    [self.bgScrollView setContentSize:self.ivBGView.frame.size];

    [self.bgScrollView setScrollEnabled:NO];
    
    [self.mainScrollView setContentSize:CGSizeMake(640, 568)];
    [self.mainScrollView setScrollEnabled:NO];
    
    [self.ivBGBlurView setImage:[self.ivBGView.image applyLightEffect]];
    
    [self.inviteCodeField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.signInView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
        [self setupSignInView];
}

-(void)setupFonts {

    [self.lblMainTitleLabel setFont:[Helpers Exo2Regular:24.0]];
    [self.lblUpcomingEvents setFont:[Helpers Exo2Regular:16.0]];
    [self.lblUpcomingEventsCount setFont:[Helpers Exo2Regular:24.0]];
    [self.inviteCodeField setFont:[Helpers Exo2Regular:14.0]];
    [self.btnCancelQRCodeScanner.titleLabel setFont:[Helpers Exo2Regular:18.0]];
}

- (IBAction)SignInButtonAction:(UIButton *)sender {

    if ([User loggedInToRaydius]) {
        
        NSLog(@"Going to Sign out");
        
        [self signOutRaydius];
    }
    else {
        
        [self.txtSignInViewEmailField setText:@""];
        [self.txtSignInViewPasswordField setText:@""];
        
        [self.mainViewContainer setHidden:YES];
       [self.signInView setHidden:NO];
        
       // [[(MainVC *)self.parentVC vMapViewContainer] setHidden:YES];
        
        //[self.view addSubview:self.signInView];
        //[self.view bringSubviewToFront:self.signInView];
        
//        self.setupSignInView;
        
        //currentView = self.signInView;
    }
}


-(IBAction)btnCreateEventAction {
    
    if (self.composeVC) {
        
        self.composeVC.mapView.delegate = nil;
        [self.composeVC.view removeFromSuperview];
        self.composeVC = nil;
    }
    if (self.eventVC) {
        
        [self.eventVC.view removeFromSuperview];
        self.eventVC = nil;
    }
    
    self.composeVC = [[ComposeVC alloc] init];
    [self.composeVC setParentVC:self];

    [self loadSecondView:self.composeVC.view];
}

-(IBAction)btnUseInviteAction {
    
    if ([self.inviteCodeField.text isEqualToString:@""]) {
     
        [self.inviteCodeField setHidden:NO];
        [self.inviteCodeField becomeFirstResponder];
    }
    else {
        
        [self openEventVC:self.inviteCodeField.text];
    }
}

-(IBAction)btnCancelQRCodeScannerAction {
    
    [self dismissScanner];
}

-(void)openEventVC:(NSString *)inviteCode username:(NSString *)username andEmail:(NSString *)email {
    
    if (self.composeVC) {
        
        self.composeVC.mapView.delegate = nil;
        [self.composeVC.view removeFromSuperview];
        self.composeVC = nil;
    }
    if (self.eventVC) {
        
        [self.eventVC.view removeFromSuperview];
        self.eventVC = nil;
    }
    
    [self hideKeyboard];
    
    self.eventVC = [[EventVC alloc] init];
    [self.eventVC setParentVC:self];
    [self.eventVC setEventInviteCode:inviteCode];
    
    if (username) {
        [self.eventVC additionalSetupForRecentEventForUsername:username andEmail:email];
    }
    
    [self loadSecondView:self.eventVC.view];
}

-(void)openEventVC:(NSString *)inviteCode {
    
    [self openEventVC:inviteCode username:nil andEmail:nil];
}

-(IBAction)signInViewCancelButtonAction:(id)sender {
    
    [self hideKeyboardAndLoad];
    
    [self.signUpView setHidden:YES];
    [self.signInView setHidden:YES];
    [self.mainViewContainer setHidden:NO];
    //[[(MainVC *)self.parentVC vMapViewContainer] setHidden:NO];
}


#pragma mark - Sign In View Methods

-(void)setupSignInView {
    
    [self.view addSubview:self.signInView];
    [self.signInView setHidden:YES];
    
//    [Helpers setBorderToView:self.btnSignInViewCancelButton borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    [Helpers setBorderToView:self.btnSignInViewSubmitButton borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    [Helpers setBorderToView:self.txtSignInViewEmailField borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    [Helpers setBorderToView:self.txtSignInViewPasswordField borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    
//    [Helpers setBorderToView:self.btnSignUpViewCancelButton borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    [Helpers setBorderToView:self.btnSignUpViewSubmitButton borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    [Helpers setBorderToView:self.txtSignUpViewEmailField borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    [Helpers setBorderToView:self.txtSignUpViewPasswordField borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    [Helpers setBorderToView:self.txtSignUpViewConfirmPasswordField borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRaydius:0.0];
//    
    [self.signInView addSubview:self.signUpView];
    [self.signUpView setHidden:YES];
    
    //[self hideKeyboard];
}

-(void)signInRaydius {
    

    
    [User signInWithRaydiusUsingEmail:self.txtSignInViewEmailField.text password:self.txtSignInViewPasswordField.text withCompletionBlock:^(NSInteger statusCode) {
        
        switch (statusCode) {
                
            case SIGN_IN_SUCCESSFUL:
                
                [self updateUIWithNewUser];
                break;
                
            case SIGN_UP_SUCCESSFUL:
                
                [self updateUIWithNewUser];
                break;
                
            case SIGN_IN_ERROR_EMAIL_DOES_NOT_EXIST:
                
                [self signUpPrompt];
                break;
                
            case SIGN_IN_ERROR_WRONG_PASSWORD:
                
                [self errorWithSignInUpPrompt];
                break;
        }
        
    }];
}

-(void)signUpRaydius {
    
    [User signUpWithRaydiusUsingEmail:self.txtSignInViewEmailField.text password:self.txtSignInViewPasswordField.text withCompletionBlock:^(NSInteger statusCode) {
        
        switch (statusCode) {
                
            case SIGN_IN_SUCCESSFUL:
                
                [self updateUIWithNewUser];
                break;
                
            case SIGN_UP_SUCCESSFUL:
                
                [self updateUIWithNewUser];
                break;
                
            case SIGN_IN_ERROR_EMAIL_DOES_NOT_EXIST:
                
                [self errorWithSignInUpPrompt];
                break;
                
            case SIGN_IN_ERROR_WRONG_PASSWORD:
                
                [self errorWithSignInUpPrompt];
                break;
        }
        
    }];
}

-(void)signOutRaydius {
    
    [User signOutOfRaydiusWithCompletionBlock:^(BOOL success) {
        
        [self updateUIWithNewUser];
    }];
}

-(void)checkSignInFields {
    
    if ([Helpers NSStringIsValidEmail:self.txtSignInViewEmailField.text]) {
        
        if (![self.txtSignInViewPasswordField.text isEqualToString:@""]) {
            
            //if email is valid and password is not blank
            
            [self signInRaydius];
        }
        else {
            
            [self invalidFieldsPrompt];
        }
    }
    else {
        
        [self invalidFieldsPrompt];
    }
}

-(void)checkSignUpFields {
    
    if ([Helpers NSStringIsValidEmail:self.txtSignUpViewEmailField.text]) {
        
        if (![self.txtSignUpViewPasswordField.text isEqualToString:@""]) {
            
            if ([self.txtSignUpViewPasswordField.text isEqualToString:self.txtSignUpViewConfirmPasswordField.text]) {
                
                //if email is valid and password is confirmed
                
                [self signUpRaydius];
            }
        }
        else {
            
            [self invalidFieldsPrompt];
        }
    }
    else {
        
        [self invalidFieldsPrompt];
    }
}

-(void)updateUIWithNewUser {
    
    [self hideKeyboardAndLoad];
    
    [self.signUpView setHidden:YES];
    [self.signInView setHidden:YES];
    [self.mainViewContainer setHidden:NO];
    [self.btnSignInOut setTitle:@"Sign out" forState:normal];
//    [[(MainVC *)self.parentVC vMapViewContainer] setHidden:NO];
    
    [self.txtSignInViewEmailField setText:@""];
    [self.txtSignInViewPasswordField setText:@""];
    [self.txtSignUpViewConfirmPasswordField setText:@""];
    [self.txtSignUpViewEmailField setText:@""];
    [self.txtSignUpViewPasswordField setText:@""];
    
    //ProfileVC
//    [self.lblUserName setText:[User currentUsername]];
//    
//    [[RDImageLoader sharedImageLoader] deleteCachedSelfAvatar];
//    
//    UIImageView *ivAvatar = [(MainVC *)self.parentVC imagePreview];
//    NSString *RDProfilePicture = [[NSUserDefaults standardUserDefaults] objectForKey:@"RDProfilePicture"];
//    if (RDProfilePicture){
//        [[HNDataManager dataManager] downloadImageWithName:RDProfilePicture withSuccess:^(UIImage *image) {
//            NSLog(@"success download from updateUI %@",image);
//            [ivAvatar setImage:image];
//        } orFailure:^(NSError *error) {
//            NSLog(@"fail download");
//        }];
//    }else{
//        [[RDImageLoader sharedImageLoader] loadAvatarForObject:ivAvatar withUsername:[User currentUsername] andUserID:[User currentUserID]];
//    }
//    
//    
//    [MyFavrsController downloadFavrTopicsForUserWithCompletionBlock:^{
//        
//        [self loadMyRequests];
//        [self loadMyTasks];
//        [self loadMyInfo];
//    }];
//    
//
    
    
    
    //set sign in button status
    if ([User loggedInToRaydius]) {

        [self.btnSignInOut setTitle:@"Sign out" forState:normal];
        NSLog(@"Sign in status");
    }
    else {
        
        [User flushRaydiusUserInfo];
        [User setRaydiusLogInStatus:NO];
        [self flushCurrentUserInfo];
        
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [appDelegate getAnonymousUserWithCompletionBlock:^(BOOL completed) {
//            NSLog(@"getting anonymous user after sign out");
//        }
//         ];
        
        [self.btnSignInOut setTitle:@"Sign In" forState:normal];
        NSLog(@"Sign out and anonymous");
        
    }
//
//    //MainVC
//    //username label
//    [self.parentVC setLblGreetings];
}

-(void)flushCurrentUserInfo {
    
    currentUserID = nil;
    currentUsername = nil;
    currentAuthToken = nil;
    currentPushToken = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"current_username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authentication_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"current_user_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"push_token"];
}

-(void)signUpPrompt {
    
    NSLog(@"TODO: prompt user if he would like to sign up first");
    
    [self.txtSignUpViewEmailField setText:self.txtSignInViewEmailField.text];
    [self.txtSignUpViewPasswordField setText:@""];
    [self.txtSignUpViewConfirmPasswordField setText:@""];
    
    [self.signUpView setHidden:NO];
    
    [self hideKeyboardAndLoad];
}

-(void)invalidFieldsPrompt {
    
    NSLog(@"TODO: check email or password and prompt user which is wrong");
}

-(void)errorWithSignInUpPrompt {
    
    NSLog(@"TODO: prompt relevant error when API returns error code");
    
    UIAlertView *signInFailedAlert = [[UIAlertView alloc] initWithTitle:@"Sign In Failed" message:@"Incorrect password entered. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [signInFailedAlert show];
}

-(IBAction)signInViewSubmitAction {
    
    [self checkSignInFields];
    [self signInRaydius];
}

-(IBAction)signUpViewSubmitAction {
    
    [self checkSignUpFields];
    [self signUpRaydius];
}



#pragma mark - SecondView Handler

-(void)loadSecondView:(UIView *)view {
    
    NSLog(@"Load second view");
    
    [self.secondViewContainer addSubview:view];
    
    [self hideKeyboard];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.mainScrollView setContentOffset:CGPointMake(320, 0) animated:NO];
        
    } completion:^(BOOL finished) {
        
        [self.mainScrollView setScrollEnabled:YES];
    }];
}

-(void)closeSecondView:(UIView *)view {
    
    NSLog(@"Close second view");
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - BGView Handler

-(void)scrollBGViewToOffset:(CGPoint)offset {
    
    [self.bgScrollView setContentOffset:CGPointMake(offset.x/4, 0)];
    
    [self.ivBGBlurView setAlpha:self.bgScrollView.contentOffset.x/80.0];
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.mainScrollView) {
        
        [self scrollBGViewToOffset:scrollView.contentOffset];
        
        if (scrollView.contentOffset.x == 0.0) {
            
            if (self.composeVC) {
                
                self.composeVC.mapView.delegate = nil;
                [self.composeVC.view removeFromSuperview];
                self.composeVC = nil;
            }
            
            if (self.eventVC) {
                
                [self.eventVC.view removeFromSuperview];
                self.eventVC = nil;
            }
            
            [self.mainScrollView setScrollEnabled:NO];
            
            [self.ivBGBlurView setAlpha:0.0];
            
            [self retrieveRecentEvents];
            [self.inviteCodeField setText:@""];
            
            NSLog(@"Reached main view");
        }
    }
}

#pragma mark - QRCode Scanner

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)setupScanner {
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.session = [[AVCaptureSession alloc] init];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:self.output];
    [self.session addInput:self.input];
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, self.codePreview.frame.size.width, self.codePreview.frame.size.height);
    
    AVCaptureConnection *con = self.preview.connection;
    
    con.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    [self.codePreview.layer insertSublayer:self.preview atIndex:0];
}

-(void)showScanner {
    
    if ([self isCameraAvailable]) {
        
        [self setupScanner];
        
        [self.codePreview setHidden:NO];
        [self.recentEventsTable setHidden:YES];
        [self.session startRunning];
        
        [self hideKeyboard];
    }
}

-(void)dismissScanner {
    
    [self.session stopRunning];
    [self.codePreview setHidden:YES];
    [self.recentEventsTable setHidden:NO];
    
    [self.preview removeFromSuperlayer];
    
    self.device = nil;
    self.input = nil;
    self.session = nil;
    self.output = nil;
    self.preview = nil;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    
    [self dismissScanner];
    
    NSString *baseHost;
    
    if ([Environment CurrentEnvironment] == STAGING) {
        baseHost = @"socal-staging.herokuapp.com";
    }
    else {
        baseHost = @"localhost:5000";
    }
    
    [NSString stringWithFormat:@"http://%@/use_invitation?i_code=", baseHost];
    
    NSString *eventBaseURL = [NSString stringWithFormat:@"http://%@/use_invitation?i_code=", baseHost];
    NSString *eventBaseURL2 = [NSString stringWithFormat:@"%@/use_invitation?i_code=", baseHost];
    NSString *eventBaseURL3 = [NSString stringWithFormat:@"http://%@/use_invitation?i=", baseHost];
    NSString *eventBaseURL4 = [NSString stringWithFormat:@"%@/use_invitation?i=", baseHost];
    NSString *eventBaseURL5 = @"http://rayd.us/socal/";
    
    for(AVMetadataObject *current in metadataObjects) {
        if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            
            NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
            
            if ([scannedValue hasPrefix:eventBaseURL]) {
                
                NSLog(@"is a socal invite code");
                
                NSString *inviteCode = [scannedValue stringByReplacingOccurrencesOfString:eventBaseURL withString:@""];
                
                [self openEventVC:inviteCode];
            }
            else if ([scannedValue hasPrefix:eventBaseURL2]) {
                
                NSLog(@"is an older socal invite code");
                
                NSString *inviteCode = [scannedValue stringByReplacingOccurrencesOfString:eventBaseURL2 withString:@""];
                
                [self openEventVC:inviteCode];
            }
            else if ([scannedValue hasPrefix:eventBaseURL3]) {
                
                NSLog(@"is an older socal invite code");
                
                NSString *inviteCode = [scannedValue stringByReplacingOccurrencesOfString:eventBaseURL3 withString:@""];
                
                [self openEventVC:inviteCode];
            }
            else if ([scannedValue hasPrefix:eventBaseURL4]) {
                
                NSLog(@"is an older socal invite code");
                
                NSString *inviteCode = [scannedValue stringByReplacingOccurrencesOfString:eventBaseURL4 withString:@""];
                
                [self openEventVC:inviteCode];
            }
            else if ([scannedValue hasPrefix:eventBaseURL5]) {
                
                NSLog(@"is an older socal invite code");
                
                NSString *inviteCode = [scannedValue stringByReplacingOccurrencesOfString:eventBaseURL5 withString:@""];
                
                [self openEventVC:inviteCode];
            }
            else {
                
                NSLog(@"is NOT a compatible QR code");
            }
        }
    }
}

-(BOOL)isCameraAvailable {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return [videoDevices count] > 0;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake) {
        
        [self showScanner];
    }
}

#pragma mark - Retrieve Recent Events

-(void)retrieveRecentEvents {
    
    [self.recentEventsArray removeAllObjects];
    
    NSArray *events = [[NSUserDefaults standardUserDefaults] objectForKey:@"recent_events_array"];
    [self.recentEventsArray addObjectsFromArray:events];
    
    [self.recentEventsTable reloadData];
    
    [self.lblUpcomingEventsCount setText:[NSString stringWithFormat:@"%i", self.recentEventsArray.count]];
}

-(void)retrieveBackgroundImage {
    
    //get URL from API, depending on requirements of how this should work.
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://3788115f29daca132b4f-ce1335d853f8573f8e5e4d725b006a21.r57.cf6.rackcdn.com/BGCropped@2x.jpg"]];
    
    [self.ivBGView setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        [self.ivBGBlurView setImage:[self.ivBGView.image applyLightEffect]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

#pragma mark - UICollectionView Delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.recentEventsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecentEventCell *cell = (RecentEventCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RECENT_EVENT_CELL" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[RecentEventCell alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    }
    
    NSDictionary *recentEventDict = [self.recentEventsArray objectAtIndex:indexPath.row];
    
    NSDate *date = [recentEventDict objectForKey:@"popular_date"];
    if (date) {
    
        NSString *dateStr = @"";
        NSString *monthStr = @"";
        NSString *dayTimeStr = @"";
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setAMSymbol:@"am"];
        [df setPMSymbol:@"pm"];
        
        [df setDateFormat:@"dd"];
        
        dateStr = [NSString stringWithFormat:@"%@",
                   [df stringFromDate:date]];
        
        [df setDateFormat:@"MMM"];
        
        monthStr = [NSString stringWithFormat:@"%@",
                    [df stringFromDate:date]];
        
        dayTimeStr = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:date]];
        
        [df setDateFormat:@"eeee, hh:mm a"];
        
        [cell.dateLabel setText:dateStr];
        [cell.monthLabel setText:monthStr];
        
        if ([dayTimeStr hasSuffix:@"am"]) {
            [cell.dateLabel setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
            [cell.monthLabel setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
        }
        else {
            [cell.dateLabel setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
            [cell.monthLabel setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
        }
    }
    else {
        
        [cell.dateLabel setText:@"?"];
        [cell.monthLabel setText:@"?"];
        
        [cell.dateLabel setBackgroundColor:[Helpers bondiBlueColorWithAlpha:1.0]];
        [cell.monthLabel setBackgroundColor:[Helpers bondiBlueColorWithAlpha:1.0]];
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *recentEventDict = [self.recentEventsArray objectAtIndex:indexPath.row];
    
    NSString *inviteCode = [recentEventDict objectForKey:@"invitation_code"];
    NSString *username = [recentEventDict objectForKey:@"username"];
    NSString *userEmail = [recentEventDict objectForKey:@"email"];
    
    [self hideKeyboard];
    
    [self openEventVC:inviteCode username:username andEmail:userEmail];
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.inviteCodeField) {
        
        [self openEventVC:self.inviteCodeField.text];
    }
    
    return YES;
}

#pragma mark - Keyboard Methods

-(void)keyboardWillShow {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.signInView setFrame:CGRectMake(0, -250, self.signInView.frame.size.width, self.signInView.frame.size.height)];
    
    [UIView commitAnimations];
    
    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downSwipe];
    
//    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    [self.view addGestureRecognizer:tapGesture];
}

-(void)keyboardWillHide {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.signInView setFrame:CGRectMake(0, 0, self.signInView.frame.size.width, self.signInView.frame.size.height)];
    
    [self.view removeGestureRecognizer:downSwipe];
//    [self.view removeGestureRecognizer:tapGesture];
}

-(void)hideKeyboardAndLoad {
    
    [self.txtSignInViewEmailField resignFirstResponder];
    [self.txtSignInViewPasswordField resignFirstResponder];
    [self.txtSignUpViewEmailField resignFirstResponder];
    [self.txtSignUpViewPasswordField resignFirstResponder];
    [self.txtSignUpViewConfirmPasswordField resignFirstResponder];
}

-(void)hideKeyboard {
    
    [self.inviteCodeField resignFirstResponder];
    [self.inviteCodeField setHidden:YES];
}

@end

@implementation RecentEventCell

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 20, 20)];
        [Helpers setBorderToView:self.dateLabel borderColor:[UIColor whiteColor] borderThickness:0.5 borderRadius:self.dateLabel.frame.size.width/2];
        [self.dateLabel setFont:[Helpers Exo2Regular:11.0]];
        [self.dateLabel setTextColor:[UIColor whiteColor]];
        [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self.dateLabel setClipsToBounds:YES];
        
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.5, 7.5, 45, 45)];
        [Helpers setBorderToView:self.monthLabel borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:self.monthLabel.frame.size.width/2];
        [self.monthLabel setFont:[Helpers Exo2Regular:16.0]];
        [self.monthLabel setTextColor:[UIColor whiteColor]];
        [self.monthLabel setTextAlignment:NSTextAlignmentCenter];
        [self.monthLabel setClipsToBounds:YES];
        
        [self addSubview:self.monthLabel];
        [self addSubview:self.dateLabel];
    }
    return self;
}

@end

