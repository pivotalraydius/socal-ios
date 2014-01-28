//
//  ComposeVC.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "ComposeVC.h"
#import "ComposeDateTimeCell.h"

@implementation ComposeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupCalendar];
    [self setupTestData];
    [self setupTimePicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTestData {
    
    self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedDateItems = [[NSMutableArray alloc] initWithCapacity:0];
    
    currentlySelectedDateTimeCell = -1;
}

-(void)setupCalendar {
    
    [self.calendarView setOnlyShowCurrentMonth:NO];
    
    [self.calendarView setBackgroundColor:[UIColor whiteColor]];
    [self.calendarView setInnerBorderColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    [self.calendarView setDayOfWeekTextColor:[UIColor whiteColor]];
 
    [self.calendarView setDelegate:self];
}

#pragma mark - Main Actions

-(IBAction)closeButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButtonAction {
    
}

#pragma mark - Time Picker Methods

-(void)setupTimePicker {
    
    [self.timePickerView addSubview:self.timePicker];
    [self.view addSubview:self.timePickerView];
    [self.timePickerView setFrame:CGRectMake(0, self.view.frame.size.height, self.timePickerView.frame.size.width, self.timePicker.frame.size.height)];
}

-(void)showTimePicker {
    
    NSDate *date = [self.eventDateTimesArray objectAtIndex:currentlySelectedDateTimeCell];
    
    [self.timePicker setDate:date];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.timePickerView setFrame:CGRectMake(0, self.view.frame.size.height - self.timePickerView.frame.size.height, self.timePickerView.frame.size.width, self.timePickerView.frame.size.height)];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.timePicker addTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideTimePicker)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downSwipe];
}

-(void)hideTimePicker {
    
    [self.view removeGestureRecognizer:downSwipe];
    downSwipe = nil;
    
    [self.timePicker removeTarget:self action:@selector(timePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.timePickerView setFrame:CGRectMake(0, self.view.frame.size.height, self.timePickerView.frame.size.width, self.timePickerView.frame.size.height)];
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)timePickerValueChanged {
    
    ComposeDateTimeCell *cell = (ComposeDateTimeCell *)[self.dateTimeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentlySelectedDateTimeCell inSection:0]];
    
    [cell updateCellWithTime:self.timePicker.date];
    [self.dateTimeTable beginUpdates];
    [self.dateTimeTable endUpdates];
    
    [self.eventDateTimesArray removeObjectAtIndex:currentlySelectedDateTimeCell];
    [self.eventDateTimesArray insertObject:self.timePicker.date atIndex:currentlySelectedDateTimeCell];
}

#pragma mark - Calendar Delegate Methods

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    if (self.eventDateTimesArray.count < 5) {
     
        [self.eventDateTimesArray addObject:date];
        [self.selectedDateItems addObject:date];
        
        [self.dateTimeTable reloadData];
        
        [self tableView:self.dateTimeTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:self.eventDateTimesArray.count-1 inSection:0]];
    }
}

-(void)calendar:(CKCalendarView *)calendar didDeselectDate:(NSDate *)date {
    
}

-(void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
//    
//    for (NSDate *aDate in self.selectedDateItems) {
//        
//        if (aDate == date) {
//            
//            [dateItem setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
//            [dateItem setTextColor:[UIColor whiteColor]];
//            
//            [calendar layoutSubviews];
//        }
//    }
}

#pragma mark - Table View Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.eventDateTimesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    ComposeDateTimeCell *cell = (ComposeDateTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"ComposeDateTimeCell"];
    
    if (!cell) {
        cell = [ComposeDateTimeCell newComposeDateTimeCell];
        [cell setParentVC:self];
    }
    
    [cell renderCellDataWithDate:[self.eventDateTimesArray objectAtIndex:indexPath.row] andIndexPathRow:indexPath.row];
     
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == currentlySelectedDateTimeCell) {
        
        return 80.0;
    }
    
    return 30.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == currentlySelectedDateTimeCell) {
        
        //already selected, deselect
        [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
    
    currentlySelectedDateTimeCell = indexPath.row;
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    currentlySelectedDateTimeCell = -1;
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

#pragma mark - ComposeDateTimeCell Actions

-(void)deleteCellAtIndexPathRow:(NSInteger)row {
 
    [self.eventDateTimesArray removeObjectAtIndex:row];
    [self.dateTimeTable reloadData];
}

-(void)editTimeForCellAtIndexPathRow:(NSInteger)row {
    
    if (row == currentlySelectedDateTimeCell)
        [self showTimePicker];
}

-(void)closeTimePanelForCellAtIndexPathRow:(NSInteger)row {
    
    [self tableView:self.dateTimeTable didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

@end
