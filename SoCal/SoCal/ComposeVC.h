//
//  ComposeVC.h
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"

@interface ComposeVC : UIViewController <CKCalendarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger currentlySelectedDateTimeCell;
    
    UISwipeGestureRecognizer *downSwipe;
}

@property (nonatomic, weak) IBOutlet CKCalendarView *calendarView;
@property (nonatomic, strong) NSMutableArray *selectedDateItems;

@property (nonatomic, weak) IBOutlet UITableView *dateTimeTable;
@property (nonatomic, strong) NSMutableArray *eventDateTimesArray;

@property (nonatomic, weak) IBOutlet UIButton *dateTimeDoneButton;

@property (nonatomic, weak) IBOutlet UIView *timePickerView;
@property (nonatomic, weak) IBOutlet UIDatePicker *timePicker;

-(void)deleteCellAtIndexPathRow:(NSInteger)row;
-(void)editTimeForCellAtIndexPathRow:(NSInteger)row;
-(void)closeTimePanelForCellAtIndexPathRow:(NSInteger)row;

@end
