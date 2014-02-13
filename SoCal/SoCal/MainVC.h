//
//  MainVCViewController.h
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventVC.h"
#import "ComposeVC.h"
#import <AVFoundation/AVFoundation.h>

@interface MainVC : UIViewController <UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate>
{
    UISwipeGestureRecognizer *downSwipe;
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong) ComposeVC *composeVC;
@property (nonatomic, strong) EventVC *eventVC;

@property (nonatomic, weak) IBOutlet UILabel *lblMainTitleLabel;
@property (nonatomic, weak) IBOutlet UIControl *btnCreateEvent;
@property (nonatomic, weak) IBOutlet UIControl *btnUseInvite;
@property (nonatomic, weak) IBOutlet UILabel *lblBtnCreateEvent;
@property (nonatomic, weak) IBOutlet UILabel *lblBtnUseInvite;

@property (nonatomic, weak) IBOutlet UITextField *inviteCodeField;

@property (nonatomic, weak) IBOutlet UIView *codePreview;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@end
