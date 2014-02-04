//
//  ComposeVC.h
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "RDLabeledTextView.h"
#import "LocationVC.h"

@interface ComposeVC : UIViewController <CKCalendarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentlySelectedDateTimeCell;
    
    UISwipeGestureRecognizer *downSwipe;
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, weak) IBOutlet CKCalendarView *calendarView;
@property (nonatomic, strong) NSMutableArray *selectedDateItems;
@property (nonatomic, strong) NSMutableArray *selectedDateItemsViews;

@property (nonatomic, weak) IBOutlet UITableView *dateTimeTable;
@property (nonatomic, strong) NSMutableArray *eventDateTimesArray;

@property (nonatomic, weak) IBOutlet UIButton *dateTimeDoneButton;

@property (nonatomic, weak) IBOutlet UIView *timePickerView;
@property (nonatomic, weak) IBOutlet UIDatePicker *timePicker;

@property (nonatomic, weak) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, weak) IBOutlet UIView *composeEventContainer;
@property (nonatomic, weak) IBOutlet UIView *timeSelectionContainer;

@property (nonatomic, weak) IBOutlet RDLabeledTextView *txtEventName;
@property (nonatomic, weak) IBOutlet RDLabeledTextView *txtDescription;

@property (nonatomic, weak) IBOutlet UIControl *btnLocation;

@property (nonatomic, weak) IBOutlet UIButton *selectDatesButton;

-(void)deleteCellAtIndexPathRow:(NSInteger)row;
-(void)editTimeForCellAtIndexPathRow:(NSInteger)row;
-(void)closeTimePanelForCellAtIndexPathRow:(NSInteger)row;

@end
