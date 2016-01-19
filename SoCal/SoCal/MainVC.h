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
#import "User.h"
#import "Helpers.h"

@interface MainVC : UIViewController <UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UISwipeGestureRecognizer *downSwipe;
    UITapGestureRecognizer *tapGesture;
    UIView *currentView;
    
    NSString *currentUsername;
    NSNumber *currentUserID;
    NSString *currentAuthToken;
    NSString *currentPushToken;
}

@property (nonatomic, strong) id parentVC;

@property (nonatomic, strong) ComposeVC *composeVC;
@property (nonatomic, strong) EventVC *eventVC;

@property (nonatomic, weak) IBOutlet UILabel *lblMainTitleLabel;
@property (nonatomic, weak) IBOutlet UIControl *btnCreateEvent;
@property (nonatomic, weak) IBOutlet UIControl *btnUseInvite;
@property (nonatomic, weak) IBOutlet UILabel *lblUpcomingEvents;
@property (nonatomic, weak) IBOutlet UILabel *lblUpcomingEventsCount;

@property (nonatomic, weak) IBOutlet UITextField *inviteCodeField;

@property (nonatomic, weak) IBOutlet UIView *codePreview;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, weak) IBOutlet UIButton *btnCancelQRCodeScanner;

@property (nonatomic, weak) IBOutlet UICollectionView *recentEventsTable;
@property (nonatomic, strong) NSMutableArray *recentEventsArray;

@property (nonatomic, weak) IBOutlet UIScrollView *bgScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, weak) IBOutlet UIImageView *ivBGOverlayView;
@property (nonatomic, weak) IBOutlet UIImageView *ivBGView;
@property (nonatomic, weak) IBOutlet UIImageView *ivBGBlurView;
@property (weak, nonatomic) IBOutlet UIButton *btnSignInOut;


@property (nonatomic, weak) IBOutlet UIView *mainViewContainer;
@property (nonatomic, weak) IBOutlet UIView *secondViewContainer;

@property (nonatomic, weak) IBOutlet UIView *signInView;
@property (nonatomic, weak) IBOutlet UILabel *lblSignInViewTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *lblSignInViewInfoLabel1;
@property (nonatomic, weak) IBOutlet UILabel *lblSignInViewInfoLabel2;
@property (nonatomic, weak) IBOutlet UILabel *lblSignInViewEmailLabel;
@property (nonatomic, weak) IBOutlet UILabel *lblSignInViewPasswordLabel;
@property (nonatomic, weak) IBOutlet UIButton *btnSignInViewCancelButton;
@property (nonatomic, weak) IBOutlet UIButton *btnSignInViewSubmitButton;
@property (nonatomic, weak) IBOutlet UITextField *txtSignInViewEmailField;
@property (nonatomic, weak) IBOutlet UITextField *txtSignInViewPasswordField;

@property (nonatomic, weak) IBOutlet UIView *signUpView;
@property (nonatomic, weak) IBOutlet UILabel *lblSignUpViewTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *lblSignUpViewInfoLabel1;
@property (nonatomic, weak) IBOutlet UILabel *lblSignUpViewInfoLabel2;
@property (nonatomic, weak) IBOutlet UILabel *lblSignUpViewEmailLabel;
@property (nonatomic, weak) IBOutlet UILabel *lblSignUpViewPasswordLabel;
@property (nonatomic, weak) IBOutlet UIButton *btnSignUpViewCancelButton;
@property (nonatomic, weak) IBOutlet UIButton *btnSignUpViewSubmitButton;
@property (nonatomic, weak) IBOutlet UITextField *txtSignUpViewEmailField;
@property (nonatomic, weak) IBOutlet UITextField *txtSignUpViewPasswordField;
@property (nonatomic, weak) IBOutlet UITextField *txtSignUpViewConfirmPasswordField;


//sign up/in panel
@property (nonatomic, weak) IBOutlet UIView *signUpInPanelContainer;
@property (nonatomic, weak) IBOutlet UITextField *signUpInPanelEmailField;
@property (nonatomic, weak) IBOutlet UITextField *signUpInPanelPasswordField;
@property (nonatomic, weak) IBOutlet UILabel *signUpInPanelEmailErrorLabel;
@property (nonatomic, weak) IBOutlet UILabel *signUpInPanelPasswordErrorLabel;
@property (nonatomic, weak) IBOutlet UIButton *signUpInPanelCancelButton;
@property (nonatomic, weak) IBOutlet UIButton *signUpInPanelSubmitButton;

//sign up panel
@property (nonatomic, weak) IBOutlet UIView *signUpPanelContainer;
@property (nonatomic, weak) IBOutlet UITextField *signUpPanelEmailField;
@property (nonatomic, weak) IBOutlet UITextField *signUpPanelPasswordField;
@property (nonatomic, weak) IBOutlet UITextField *signUpPanelConfirmPasswordField;
@property (nonatomic, weak) IBOutlet UILabel *signUpPanelEmailErrorLabel;
@property (nonatomic, weak) IBOutlet UILabel *signUpPanelPasswordErrorLabel;
@property (nonatomic, weak) IBOutlet UIButton *signUpPanelCancelButton;
@property (nonatomic, weak) IBOutlet UIButton *signUpPanelSubmitButton;


-(void)openEventVC:(NSString *)inviteCode;
-(void)openEventVC:(NSString *)inviteCode username:(NSString *)username andEmail:(NSString *)email;
-(void)closeSecondView:(UIView *)view;
-(void)scrollBGViewToOffset:(CGPoint)offset;

@end

@interface RecentEventCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *monthLabel;

-(id)initWithFrame:(CGRect)frame;

@end