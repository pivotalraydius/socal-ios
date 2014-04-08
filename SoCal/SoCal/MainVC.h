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

@interface MainVC : UIViewController <UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UISwipeGestureRecognizer *downSwipe;
    UITapGestureRecognizer *tapGesture;
}

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

@property (nonatomic, weak) IBOutlet UIView *mainViewContainer;
@property (nonatomic, weak) IBOutlet UIView *secondViewContainer;

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