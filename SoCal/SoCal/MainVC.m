//
//  MainVCViewController.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "MainVC.h"
#import "UIImage+ImageEffects.h"

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
    
    [self.inviteCodeField setText:@""];
    [self.inviteCodeField setHidden:YES];
    
    [super viewWillAppear:animated];
    
    [self becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self retrieveRecentEvents];
    
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
}

-(void)setupFonts {

    [self.lblMainTitleLabel setFont:[Helpers Exo2Regular:24.0]];
    [self.lblUpcomingEvents setFont:[Helpers Exo2Regular:16.0]];
    [self.lblUpcomingEventsCount setFont:[Helpers Exo2Regular:24.0]];
    [self.inviteCodeField setFont:[Helpers Exo2Regular:14.0]];
    [self.btnCancelQRCodeScanner.titleLabel setFont:[Helpers Exo2Regular:18.0]];
}

-(IBAction)btnCreateEventAction {
    
    self.composeVC = [[ComposeVC alloc] init];
    [self.composeVC setParentVC:self];
//    [self.navigationController pushViewController:self.composeVC animated:YES];
    [self loadSecondView:self.composeVC.view];
}

-(IBAction)btnUseInviteAction {
    
    if ([self.inviteCodeField.text isEqualToString:@""]) {
     
        [self.inviteCodeField setHidden:NO];
        [self.inviteCodeField becomeFirstResponder];
    }
    else {
        
        [self openEventVC];
    }
}

-(IBAction)btnCancelQRCodeScannerAction {
    
    [self dismissScanner];
}

-(void)openEventVC {
    
    [self hideKeyboard];
    
    self.eventVC = [[EventVC alloc] init];
    [self.eventVC setParentVC:self];
    [self.eventVC setEventInviteCode:self.inviteCodeField.text];
//    [self.navigationController pushViewController:self.eventVC animated:YES];
    [self loadSecondView:self.eventVC.view];
}

#pragma mark - SecondView Handler

-(void)loadSecondView:(UIView *)view {
    
    [self.secondViewContainer addSubview:view];
    
    [self.mainScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    [self.mainScrollView setScrollEnabled:YES];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        [self.mainScrollView setContentOffset:CGPointMake(320, 0) animated:NO];
//        
//    } completion:^(BOOL finished) {
//        
//        [self.mainScrollView setScrollEnabled:YES];
//    }];
}

-(void)closeSecondView:(UIView *)view {
    
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
                
                [self.composeVC.view removeFromSuperview];
                self.composeVC = nil;
            }
            
            if (self.eventVC) {
                
                [self.eventVC.view removeFromSuperview];
                self.eventVC = nil;
            }
            
            [self.mainScrollView setScrollEnabled:NO];
            
            [self.ivBGBlurView setAlpha:0.0];
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
    
    for(AVMetadataObject *current in metadataObjects) {
        if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            
            NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
            
            if ([scannedValue hasPrefix:@"http://rayd.us/socal/"] && scannedValue.length == 39) {
                
                NSLog(@"is a socal invite code");
                
                NSString *inviteCode = [scannedValue stringByReplacingOccurrencesOfString:@"http://rayd.us/socal/" withString:@""];
                
                self.eventVC = [[EventVC alloc] init];
                [self.eventVC setEventInviteCode:inviteCode];
                [self.navigationController pushViewController:self.eventVC animated:YES];
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
    
    [self hideKeyboard];
    
    self.eventVC = [[EventVC alloc] init];
    [self.eventVC setParentVC:self];
    [self.eventVC setEventInviteCode:inviteCode];
    [self.eventVC additionalSetupForRecentEvent:username];
//    [self.navigationController pushViewController:self.eventVC animated:YES];
    [self loadSecondView:self.eventVC.view];
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.inviteCodeField) {
        
        [self openEventVC];
    }
    
    return YES;
}

#pragma mark - Keyboard Methods

-(void)keyboardWillShow {
    
    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downSwipe];
    
//    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    [self.view addGestureRecognizer:tapGesture];
}

-(void)keyboardWillHide {
    
    [self.view removeGestureRecognizer:downSwipe];
//    [self.view removeGestureRecognizer:tapGesture];
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
        
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.5, 7.5, 45, 45)];
        [Helpers setBorderToView:self.monthLabel borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:self.monthLabel.frame.size.width/2];
        [self.monthLabel setFont:[Helpers Exo2Regular:16.0]];
        [self.monthLabel setTextColor:[UIColor whiteColor]];
        [self.monthLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:self.monthLabel];
        [self addSubview:self.dateLabel];
    }
    return self;
}

@end

