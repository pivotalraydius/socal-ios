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
    
    [self setupTestData];
    [self setupMainScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTestData {
    
    self.eventDateTimesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedDateItems = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedDateItemsViews = [[NSMutableArray alloc] initWithCapacity:0];
    
    currentlySelectedDateTimeCell = -1;
}

-(void)setupMainScrollView {
    
    [self.mainScrollView addSubview:self.composeEventContainer];
    
    [self.composeEventContainer setFrame:CGRectMake(0, 0, self.composeEventContainer.frame.size.width, self.composeEventContainer.frame.size.height)];
    
    [self setupComposeEventContainer];
    
    [self.mainScrollView addSubview:self.timeSelectionContainer];
    
    [self.timeSelectionContainer setFrame:CGRectMake(320, 0, self.timeSelectionContainer.frame.size.width, self.timeSelectionContainer.frame.size.height)];
    
    [self setupTimeSelectionContainer];
    
    [self.mainScrollView setScrollEnabled:NO];
}

-(void)setupComposeEventContainer {
    
    [Helpers setBorderToView:self.txtEventName borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
    [Helpers setBorderToView:self.txtLocation borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
    [Helpers setBorderToView:self.txtDescription borderColor:[Helpers bondiBlueColorWithAlpha:1.0] borderThickness:1.0 borderRadius:0.0];
}

-(void)setupTimeSelectionContainer {
 
    [self setupCalendar];
    [self setupTimePicker];
}

-(void)setupCalendar {
    
    [self.calendarView setOnlyShowCurrentMonth:NO];
    
    [self.calendarView setBackgroundColor:[UIColor whiteColor]];
    [self.calendarView setInnerBorderColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    [self.calendarView setDayOfWeekTextColor:[UIColor whiteColor]];
    [self.calendarView setDateFont:[UIFont systemFontOfSize:10.0]];
 
    [self.calendarView setDelegate:self];
}

-(void)scrollToTimeSelection {
    
    [self.mainScrollView setContentOffset:CGPointMake(320.0, 0.0) animated:YES];
}

-(void)scrollToComposeEvent {
    
    [self.mainScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

#pragma mark - Main Actions

-(IBAction)closeButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneButtonAction {
    
    [self scrollToComposeEvent];
}

-(IBAction)selectDatesAction {
    
    [self scrollToTimeSelection];
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
    
//    [self.selectedDateItems removeObjectAtIndex:currentlySelectedDateTimeCell];
//    [self.selectedDateItems insertObject:self.timePicker.date atIndex:currentlySelectedDateTimeCell];
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
    [self.selectedDateItems removeObjectAtIndex:row];
    [self.dateTimeTable reloadData];
    
    [self updateCalendarSubviews];
}

-(void)editTimeForCellAtIndexPathRow:(NSInteger)row {
    
    if (row == currentlySelectedDateTimeCell)
        [self showTimePicker];
}

-(void)closeTimePanelForCellAtIndexPathRow:(NSInteger)row {
    
    [self updateCalendarSubviews];
    
    [self tableView:self.dateTimeTable didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

-(void)updateCalendarSubviews {
    
    [self.selectedDateItemsViews removeAllObjects];
    
    for (NSDate *dateToAdd in self.selectedDateItems) {
        
        NSDate *timeDate = [self.eventDateTimesArray objectAtIndex:[self.selectedDateItems indexOfObject:dateToAdd]];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(3.5, 3.5, 30, 30)];
        [view setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
        [view.layer setCornerRadius:view.frame.size.height/2];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:10.0]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d, EEEE, hh:mm a"];
        [dateFormatter setAMSymbol:@"am"];
        [dateFormatter setPMSymbol:@"pm"];
        
        NSString *dateString = [dateFormatter stringFromDate:timeDate];
        
        if ([dateString hasSuffix:@"am"]) {
            [view setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
        }
        else {
            [view setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
        }
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"hh:mm"];
        
        NSString *dateString2 = [dateFormatter2 stringFromDate:timeDate];
        NSString *displayString2 = dateString2;
        [label setText:displayString2];
        
        [view addSubview:label];
        
        [view setTag:666];
        
        [self.selectedDateItemsViews addObject:view];
    }
    
    [self.calendarView setSubviews:self.selectedDateItemsViews toDateButtonWithDate:self.selectedDateItems];
    
    [self.calendarView reloadData];
}

#pragma mark - Keyboard Methods

-(void)keyboardWillShow {
    
    downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downSwipe];
}

-(void)keyboardWillHide {
    
    [self.view removeGestureRecognizer:downSwipe];
}

-(void)hideKeyboard {
    
    [self.txtEventName resignFirstResponder];
    [self.txtLocation resignFirstResponder];
    [self.txtDescription resignFirstResponder];
}

@end
