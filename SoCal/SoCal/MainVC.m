//
//  MainVCViewController.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "MainVC.h"

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [self.inviteCodeField setText:@""];
    [self.inviteCodeField setHidden:YES];
    
    [super viewWillAppear:animated];
    
    [self becomeFirstResponder];
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
    
    [self setupScanner];
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
    
    [self.inviteCodeField setHidden:YES];
    
    [Helpers setBorderToView:self.btnCreateEvent borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
    [Helpers setBorderToView:self.btnUseInvite borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
}

-(void)setupFonts {

    [self.lblMainTitleLabel setFont:[Helpers Exo2Regular:24.0]];
    [self.lblBtnCreateEvent setFont:[Helpers Exo2Regular:18.0]];
    [self.lblBtnUseInvite setFont:[Helpers Exo2Regular:18.0]];
    [self.inviteCodeField setFont:[Helpers Exo2Regular:14.0]];
}

-(IBAction)btnCreateEventAction {
    
    self.composeVC = [[ComposeVC alloc] init];
    [self.navigationController pushViewController:self.composeVC animated:YES];
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

-(void)openEventVC {
    
    [self hideKeyboard];
    
    self.eventVC = [[EventVC alloc] init];
    [self.eventVC setEventInviteCode:self.inviteCodeField.text];
    [self.navigationController pushViewController:self.eventVC animated:YES];
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
        
        [self.codePreview setHidden:NO];
        [self.session startRunning];
    }
}

-(void)dismissScanner {
    
    [self.session stopRunning];
    [self.codePreview setHidden:YES];
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
        
        if (self.codePreview.hidden)
            [self showScanner];
        else
            [self dismissScanner];
    }
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
