//
//  EventVC.h
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CKCalendarView.h"

@interface EventVC : UIViewController <UIScrollViewDelegate>
{
    BOOL hasName;
    
    UISwipeGestureRecognizer *downSwipe;
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, weak) IBOutlet UIView *detailsView;
@property (nonatomic, weak) IBOutlet UIView *datesView;
@property (nonatomic, weak) IBOutlet UIView *doneView;

@property (nonatomic, weak) IBOutlet UILabel *lblTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton *mainBackButton;
@property (nonatomic, weak) IBOutlet UIButton *mainDoneButton;

@property (nonatomic, weak) IBOutlet UITableView *postsTable;

@property (nonatomic, weak) IBOutlet UIView *bottomBar;
@property (nonatomic, weak) IBOutlet UILabel *lblEnterNamePrompt;
@property (nonatomic, weak) IBOutlet UIView *postsInputView;
@property (nonatomic, weak) IBOutlet UIView *nameInputView;

@property (nonatomic, weak) IBOutlet UITextField *txtPostField;
@property (nonatomic, weak) IBOutlet UITextField *txtNameField;
@property (nonatomic, weak) IBOutlet UIButton *btnPostButton;
@property (nonatomic, weak) IBOutlet UIButton *btnNameOkButton;

@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic, weak) IBOutlet UILabel *lblDetailsEventTitle;
@property (nonatomic, weak) IBOutlet UIScrollView *svEventInfoScrollView;

@property (nonatomic, weak) IBOutlet UIView *detailsInfoView;
@property (nonatomic, weak) IBOutlet UIView *detailsLocationView;

@property (nonatomic, weak) IBOutlet UILabel *lblDetailsInfo;
@property (nonatomic, weak) IBOutlet MKMapView *detailsMapView;
@property (nonatomic, weak) IBOutlet UIButton *detailsInfoScrollToMapButton;
@property (nonatomic, weak) IBOutlet UIButton *detailsInfoScrollToInfoButton;

@property (nonatomic, weak) IBOutlet CKCalendarView *calEventDatesCalendar;

@property (nonatomic, weak) IBOutlet UIView *actionBar;
@property (nonatomic, weak) IBOutlet UIView *eventDateYesPiece;
@property (nonatomic, weak) IBOutlet UIView *eventDateNoPiece;
@property (nonatomic, weak) IBOutlet UIView *eventDateMaybePiece;
@property (nonatomic, weak) IBOutlet UILabel *lblEventDateInstruction;

@property (nonatomic, weak) IBOutlet UITableView *doneDatesTableView;
@property (nonatomic, weak) IBOutlet UILabel *lblDoneSummaryLabel;

@property (nonatomic, strong) NSNumber *eventInviteCode;
@property (nonatomic, strong) NSString *eventUserName;

@end
