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

@interface MainVC : UIViewController

@property (nonatomic, strong) ComposeVC *composeVC;
@property (nonatomic, strong) EventVC *eventVC;

@property (nonatomic, weak) IBOutlet UILabel *lblMainTitleLabel;
@property (nonatomic, weak) IBOutlet UIControl *btnCreateEvent;
@property (nonatomic, weak) IBOutlet UIControl *btnUseInvite;
@property (nonatomic, weak) IBOutlet UILabel *lblBtnCreateEvent;
@property (nonatomic, weak) IBOutlet UILabel *lblBtnUseInvite;

@end
