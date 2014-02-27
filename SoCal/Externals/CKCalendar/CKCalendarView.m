//
// Copyright (c) 2012 Jason Kozemczak
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//


#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "CKCalendarView.h"

#define BUTTON_MARGIN 0
#define CALENDAR_MARGIN 5
#define TOP_HEIGHT 30
#define DAYS_HEADER_HEIGHT 20
#define DEFAULT_CELL_WIDTH 43
#define DEFAULT_CELL_HEIGHT 35
#define CELL_BORDER_WIDTH 0

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@class CALayer;
@class CAGradientLayer;

@interface GradientView : UIView

@property(nonatomic, strong, readonly) CAGradientLayer *gradientLayer;
- (void)setColors:(NSArray *)colors;

@end

@implementation GradientView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

- (void)setColors:(NSArray *)colors {
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    self.gradientLayer.colors = cgColors;
}

@end


@interface DateButton : UIButton

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CKDateItem *dateItem;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation DateButton

- (void)setDate:(NSDate *)date {
    _date = date;
    if (date) {
        NSDateComponents *comps = [self.calendar components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:date];
        [self setTitle:[NSString stringWithFormat:@"%ld", (long)comps.day] forState:UIControlStateNormal];
    } else {
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

@end

//@interface DateButtonView : UIControl
//
//@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) NSDate *date;
//@property (nonatomic, strong) CKDateItem *dateItem;
//@property (nonatomic, strong) NSCalendar *calendar;
//
//@end
//
//@implementation DateButtonView
//
//@end

@implementation CKDateItem

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
        self.selectedBackgroundColor = [UIColor whiteColor];
        self.textColor = [UIColor blackColor];
        self.selectedTextColor = [UIColor blackColor];
    }
    return self;
}

@end

@interface CKCalendarView ()

@property(nonatomic, strong) UIView *highlight;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *prevButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UIView *calendarContainer;
//@property(nonatomic, strong) GradientView *daysHeader;
@property(nonatomic, strong) UIView *daysHeader;
@property(nonatomic, strong) NSArray *dayOfWeekLabels;
@property(nonatomic, strong) NSMutableArray *dateButtons;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDateFormatter *dateFormatter2;

@property (nonatomic, strong) NSDate *monthShowing;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSCalendar *calendar;
@property(nonatomic, assign) CGFloat cellWidth;
@property(nonatomic, assign) CGFloat cellHeight;

@end

@implementation CKCalendarView

@dynamic locale;

- (id)init {
    return [self initWithStartDay:startMonday];
}

- (id)initWithStartDay:(CKCalendarStartDay)firstDay {
    return [self initWithStartDay:firstDay frame:CGRectMake(0, 0, 320, 320)];
}

- (void)_init:(CKCalendarStartDay)firstDay {
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [self.calendar setLocale:[NSLocale currentLocale]];

    self.cellWidth = DEFAULT_CELL_WIDTH;
    self.cellHeight = DEFAULT_CELL_HEIGHT;

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateFormatter.dateFormat = @"LLLL yyyy";
    
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    [self.dateFormatter2 setTimeStyle:NSDateFormatterNoStyle];
    self.dateFormatter2.dateFormat = @"LLLL";

    self.calendarStartDay = firstDay;
    self.onlyShowCurrentMonth = YES;
    self.adaptHeightToNumberOfWeeksInMonth = YES;
    
    self.nextButtonModifier = 0.0;

//    self.layer.cornerRadius = 6.0f;

//    UIView *highlight = [[UIView alloc] initWithFrame:CGRectZero];
//    highlight.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
//    highlight.layer.cornerRadius = 6.0f;
//    [self addSubview:highlight];
//    self.highlight = highlight;

    // SET UP THE HEADER
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;

//    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [prevButton setImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
//    prevButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
//    [prevButton addTarget:self action:@selector(_moveCalendarToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
//    [prevButton setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
//    [self addSubview:prevButton];
//    self.prevButton = prevButton;
//
//    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [nextButton setImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
//    nextButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
//    [nextButton addTarget:self action:@selector(_moveCalendarToNextMonth) forControlEvents:UIControlEventTouchUpInside];
//    [nextButton setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
//    [self addSubview:nextButton];
//    self.nextButton = nextButton;
    
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [dateComponents setMonth:-1];
    NSDate* prevMth = [calendar dateByAddingComponents:dateComponents toDate:_monthShowing options:0];
    [dateComponents setMonth:1];
    NSDate* nextMth = [calendar dateByAddingComponents:dateComponents toDate:_monthShowing options:0];
    
    UIButton *prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [prevButton addTarget:self action:@selector(_moveCalendarToPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
    [prevButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [prevButton.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [prevButton setClipsToBounds:NO];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [nextButton addTarget:self action:@selector(_moveCalendarToNextMonth) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [nextButton setClipsToBounds:NO];
    
    [prevButton setTitle:[self.dateFormatter2 stringFromDate:[self _firstDayOfMonthContainingDate:prevMth]] forState:UIControlStateNormal];
    [nextButton setTitle:[self.dateFormatter2 stringFromDate:[self _firstDayOfMonthContainingDate:nextMth]] forState:UIControlStateNormal];
    
    [self addSubview:prevButton];
    [self addSubview:nextButton];
    
    [self setClipsToBounds:NO];
    
    self.prevButton = prevButton;
    self.nextButton = nextButton;

    // THE CALENDAR ITSELF
    UIView *calendarContainer = [[UIView alloc] initWithFrame:CGRectZero];
    calendarContainer.layer.borderWidth = 1.0f;
//    calendarContainer.layer.borderColor = [UIColor blackColor].CGColor;
    calendarContainer.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//    calendarContainer.layer.cornerRadius = 4.0f;
    calendarContainer.clipsToBounds = YES;
    [self addSubview:calendarContainer];
    self.calendarContainer = calendarContainer;

//    GradientView *daysHeader = [[GradientView alloc] initWithFrame:CGRectZero];
//    daysHeader.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
//    [self.calendarContainer addSubview:daysHeader];
//    self.daysHeader = daysHeader;

    UIView *daysHeader = [[UIView alloc] initWithFrame:CGRectZero];
    daysHeader.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self.calendarContainer addSubview:daysHeader];
    self.daysHeader = daysHeader;
    
    NSMutableArray *labels = [NSMutableArray array];
    for (int i = 0; i < 7; ++i) {
        UILabel *dayOfWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
        dayOfWeekLabel.backgroundColor = [Helpers suriaOrangeColorWithAlpha:1.0];
        [labels addObject:dayOfWeekLabel];
        [self.calendarContainer addSubview:dayOfWeekLabel];
    }
    self.dayOfWeekLabels = labels;
    [self _updateDayOfWeekLabels];

    // at most we'll need 42 buttons, so let's just bite the bullet and make them now...
    NSMutableArray *dateButtons = [NSMutableArray array];
    for (NSInteger i = 1; i <= 42; i++) {
        DateButton *dateButton = [DateButton buttonWithType:UIButtonTypeCustom];
        dateButton.calendar = self.calendar;
        [dateButton addTarget:self action:@selector(_dateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [dateButtons addObject:dateButton];
    }
    self.dateButtons = dateButtons;
    
    selectedDatesViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    selectedDatesArray = [[NSMutableArray alloc] initWithCapacity:0];

    // initialize the thing
    self.monthShowing = [NSDate date];
    [self _setDefaultStyle];
    
    [self layoutSubviews]; // TODO: this is a hack to get the first month to show properly
}

- (id)initWithStartDay:(CKCalendarStartDay)firstDay frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init:firstDay];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithStartDay:startSunday frame:frame];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init:startMonday];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat containerWidth = self.bounds.size.width - (CALENDAR_MARGIN * 2);
    self.cellWidth = (floorf(containerWidth / 7.0)) - CELL_BORDER_WIDTH;

    NSInteger numberOfWeeksToShow = 6;
    if (self.adaptHeightToNumberOfWeeksInMonth) {
        numberOfWeeksToShow = [self _numberOfWeeksInMonthContainingDate:self.monthShowing];
    }
//    CGFloat containerHeight = (numberOfWeeksToShow * (self.cellWidth + CELL_BORDER_WIDTH) + DAYS_HEADER_HEIGHT);
    CGFloat containerHeight = (numberOfWeeksToShow * (self.cellHeight + CELL_BORDER_WIDTH) + DAYS_HEADER_HEIGHT);

    CGRect newFrame = self.frame;
    newFrame.size.height = containerHeight + CALENDAR_MARGIN + TOP_HEIGHT;
    self.frame = newFrame;

//    self.highlight.frame = CGRectMake(1, 1, self.bounds.size.width - 2, 1);

    self.titleLabel.text = [self.dateFormatter stringFromDate:_monthShowing];
    self.titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width + self.nextButtonModifier, TOP_HEIGHT);
    self.prevButton.frame = CGRectMake(BUTTON_MARGIN + 5, BUTTON_MARGIN, 70, 30);
    self.nextButton.frame = CGRectMake(self.bounds.size.width - 70 - 9 - BUTTON_MARGIN + self.nextButtonModifier, BUTTON_MARGIN, 70, 30);
    [self.prevButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.nextButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    [self.prevButton setBackgroundColor:[UIColor blueColor]];
//    [self.nextButton setBackgroundColor:[UIColor blueColor]];
    
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [dateComponents setMonth:-1];
    NSDate* prevMth = [calendar dateByAddingComponents:dateComponents toDate:_monthShowing options:0];
    [dateComponents setMonth:1];
    NSDate* nextMth = [calendar dateByAddingComponents:dateComponents toDate:_monthShowing options:0];
    
    [self.prevButton setTitle:[self.dateFormatter2 stringFromDate:[self _firstDayOfMonthContainingDate:prevMth]] forState:UIControlStateNormal];
    [self.nextButton setTitle:[self.dateFormatter2 stringFromDate:[self _firstDayOfMonthContainingDate:nextMth]] forState:UIControlStateNormal];

    self.calendarContainer.frame = CGRectMake(CALENDAR_MARGIN, CGRectGetMaxY(self.titleLabel.frame), containerWidth - CALENDAR_MARGIN, containerHeight);
    self.daysHeader.frame = CGRectMake(0, 0, self.calendarContainer.frame.size.width, DAYS_HEADER_HEIGHT);

    CGRect lastDayFrame = CGRectZero;
    for (UILabel *dayLabel in self.dayOfWeekLabels) {
        dayLabel.frame = CGRectMake(CGRectGetMaxX(lastDayFrame) + CELL_BORDER_WIDTH, lastDayFrame.origin.y, self.cellWidth, self.daysHeader.frame.size.height);
        lastDayFrame = dayLabel.frame;
    }

    for (DateButton *dateButton in self.dateButtons) {
        dateButton.date = nil;
        [dateButton removeFromSuperview];
    }

    NSDate *date = [self _firstDayOfMonthContainingDate:self.monthShowing];
    if (!self.onlyShowCurrentMonth) {
        while ([self _placeInWeekForDate:date] != 0) {
            date = [self _previousDay:date];
        }
    }

    NSDate *endDate = [self _firstDayOfNextMonthContainingDate:self.monthShowing];
    if (!self.onlyShowCurrentMonth) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setWeek:numberOfWeeksToShow];
        endDate = [self.calendar dateByAddingComponents:comps toDate:date options:0];
    }

    NSUInteger dateButtonPosition = 0;
    while ([date laterDate:endDate] != date) {
        DateButton *dateButton = [self.dateButtons objectAtIndex:dateButtonPosition];

        dateButton.date = date;
        CKDateItem *item = [[CKDateItem alloc] init];
//        if ([self _dateIsToday:dateButton.date]) {
//            item.textColor = UIColorFromRGB(0xF2F2F2);
//            item.backgroundColor = [UIColor lightGrayColor];
//        } else
        if (!self.onlyShowCurrentMonth && [self _compareByMonth:date toDate:self.monthShowing] != NSOrderedSame) {
            item.textColor = [UIColor lightGrayColor];
            [dateButton.titleLabel setAlpha:1.0];
            [dateButton setEnabled:NO];
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(calendar:configureDateItem:forDate:)]) {
            [self.delegate calendar:self configureDateItem:item forDate:date];
        }

        if (self.selectedDate && [self date:self.selectedDate isSameDayAsDate:date]) {
            [dateButton setTitleColor:item.selectedTextColor forState:UIControlStateNormal];
            dateButton.backgroundColor = item.selectedBackgroundColor;
        } else {
            [dateButton setTitleColor:item.textColor forState:UIControlStateNormal];
            dateButton.backgroundColor = item.backgroundColor;
        }

        dateButton.frame = [self _calculateDayCellFrame:date];
        [Helpers setBorderToView:dateButton borderColor:[Helpers suriaOrangeColorWithAlpha:1.0] borderThickness:.5 borderRadius:0];
        
        /* OVER HERE!!!!!!! ------------------------------------------------- */
        /* OVER HERE!!!!!!! ------------------------------------------------- */
        
        for (NSInteger i = 0; i < selectedDatesArray.count; i++) {
            
            NSDate *dateForButton = [selectedDatesArray objectAtIndex:i];
            UIView *viewForDate = [selectedDatesViewsArray objectAtIndex:i];
            
            if ([self date:dateForButton isSameDayAsDate:dateButton.date]) {
                
                if (!self.onlyShowCurrentMonth && [self _compareByMonth:date toDate:self.monthShowing] != NSOrderedSame) {
                    [dateButton addSubview:viewForDate];
                    [viewForDate setAlpha:0.3];
                    [dateButton.titleLabel setAlpha:0.0];
                }
                else {
                    [dateButton addSubview:viewForDate];
                    [viewForDate setAlpha:1.0];
                }
            }
        }
        
        /* UP HERE!!!!!!! ------------------------------------------------- */
        /* UP HERE!!!!!!! ------------------------------------------------- */

        [self.calendarContainer addSubview:dateButton];

        date = [self _nextDay:date];
        dateButtonPosition++;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendar:didLayoutInRect:)]) {
        [self.delegate calendar:self didLayoutInRect:self.frame];
    }
}

-(void)setSubviews:(NSArray *)views toDateButtonWithDate:(NSArray *)dateArray {
    
    [selectedDatesArray removeAllObjects];
    [selectedDatesViewsArray removeAllObjects];
    
    [self clearDateButtonSubviews];
    
    [selectedDatesArray addObjectsFromArray:dateArray];
    [selectedDatesViewsArray addObjectsFromArray:views];
}

-(void)clearDateButtonSubviews {
    
    for (DateButton *dateButton in self.dateButtons) {
        
        UIView *subviewToRemove = [dateButton viewWithTag:666];
        [subviewToRemove removeFromSuperview];
        subviewToRemove = nil;
    }
}

-(NSArray *)getDateButtons {
    
    return self.dateButtons;
}

- (void)_updateDayOfWeekLabels {
    NSArray *weekdays = [self.dateFormatter shortWeekdaySymbols];
    // adjust array depending on which weekday should be first
    NSUInteger firstWeekdayIndex = [self.calendar firstWeekday] - 1;
    if (firstWeekdayIndex > 0) {
        weekdays = [[weekdays subarrayWithRange:NSMakeRange(firstWeekdayIndex, 7 - firstWeekdayIndex)]
                    arrayByAddingObjectsFromArray:[weekdays subarrayWithRange:NSMakeRange(0, firstWeekdayIndex)]];
    }

    NSUInteger i = 0;
    for (NSString *day in weekdays) {
        [[self.dayOfWeekLabels objectAtIndex:i] setText:day];
        i++;
    }
}

- (void)setCalendarStartDay:(CKCalendarStartDay)calendarStartDay {
    _calendarStartDay = calendarStartDay;
    [self.calendar setFirstWeekday:self.calendarStartDay];
    [self _updateDayOfWeekLabels];
    [self setNeedsLayout];
}

- (void)setLocale:(NSLocale *)locale {
    [self.dateFormatter setLocale:locale];
    [self _updateDayOfWeekLabels];
    [self setNeedsLayout];
}

- (NSLocale *)locale {
    return self.dateFormatter.locale;
}

- (NSArray *)datesShowing {
    NSMutableArray *dates = [NSMutableArray array];
    // NOTE: these should already be in chronological order
    for (DateButton *dateButton in self.dateButtons) {
        if (dateButton.date) {
            [dates addObject:dateButton.date];
        }
    }
    return dates;
}

- (void)setMonthShowing:(NSDate *)aMonthShowing {
    _monthShowing = [self _firstDayOfMonthContainingDate:aMonthShowing];
    [self setNeedsLayout];
}

- (void)setOnlyShowCurrentMonth:(BOOL)onlyShowCurrentMonth {
    _onlyShowCurrentMonth = onlyShowCurrentMonth;
    [self setNeedsLayout];
}

- (void)setAdaptHeightToNumberOfWeeksInMonth:(BOOL)adaptHeightToNumberOfWeeksInMonth {
    _adaptHeightToNumberOfWeeksInMonth = adaptHeightToNumberOfWeeksInMonth;
    [self setNeedsLayout];
}

- (void)selectDate:(NSDate *)date makeVisible:(BOOL)visible {
    NSMutableArray *datesToReload = [NSMutableArray array];
    if (self.selectedDate) {
        [datesToReload addObject:self.selectedDate];
    }
    if (date) {
        [datesToReload addObject:date];
    }
    self.selectedDate = date;
    [self reloadDates:datesToReload];
    if (visible && date) {
        self.monthShowing = date;
    }
}

- (void)reloadData {
    self.selectedDate = nil;
    [self setNeedsLayout];
}

- (void)reloadDates:(NSArray *)dates {
    // TODO: only update the dates specified
    [self setNeedsLayout];
}

- (void)_setDefaultStyle {
    self.backgroundColor = UIColorFromRGB(0x393B40);

    [self setTitleColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    [self setTitleFont:[UIFont boldSystemFontOfSize:17.0]];

    [self setDayOfWeekFont:[Helpers Exo2Regular:12.0]];
    [self setDayOfWeekTextColor:[UIColor whiteColor]];
    [self setDayOfWeekBottomColor:UIColorFromRGB(0xCCCFD5) topColor:[UIColor whiteColor]];

    [self setDateFont:[UIFont boldSystemFontOfSize:16.0f]];
    [self setDateBorderColor:[UIColor clearColor]];
}

- (CGRect)_calculateDayCellFrame:(NSDate *)date {
    NSInteger numberOfDaysSinceBeginningOfThisMonth = [self _numberOfDaysFromDate:self.monthShowing toDate:date];
    NSInteger row = (numberOfDaysSinceBeginningOfThisMonth + [self _placeInWeekForDate:self.monthShowing]) / 7;
	
    NSInteger placeInWeek = [self _placeInWeekForDate:date];

//    return CGRectMake(placeInWeek * (self.cellWidth + CELL_BORDER_WIDTH), (row * (self.cellWidth + CELL_BORDER_WIDTH)) + CGRectGetMaxY(self.daysHeader.frame) + CELL_BORDER_WIDTH, self.cellWidth, self.cellWidth);
    return CGRectMake(placeInWeek * (self.cellWidth + CELL_BORDER_WIDTH), (row * (self.cellHeight + CELL_BORDER_WIDTH)) + CGRectGetMaxY(self.daysHeader.frame) + CELL_BORDER_WIDTH, self.cellWidth, self.cellHeight);
}

- (void)_moveCalendarToNextMonth {
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSDate *newMonth = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
    if ([self.delegate respondsToSelector:@selector(calendar:willChangeToMonth:)] && ![self.delegate calendar:self willChangeToMonth:newMonth]) {
        return;
    } else {
        self.monthShowing = newMonth;
        if ([self.delegate respondsToSelector:@selector(calendar:didChangeToMonth:)] ) {
            [self.delegate calendar:self didChangeToMonth:self.monthShowing];
        }
    }
    
    [self clearDateButtonSubviews];
    [self layoutSubviews];
}

- (void)_moveCalendarToPreviousMonth {
    NSDateComponents* comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSDate *newMonth = [self.calendar dateByAddingComponents:comps toDate:self.monthShowing options:0];
    if ([self.delegate respondsToSelector:@selector(calendar:willChangeToMonth:)] && ![self.delegate calendar:self willChangeToMonth:newMonth]) {
        return;
    } else {
        self.monthShowing = newMonth;
        if ([self.delegate respondsToSelector:@selector(calendar:didChangeToMonth:)] ) {
            [self.delegate calendar:self didChangeToMonth:self.monthShowing];
        }
    }
    
    [self clearDateButtonSubviews];
    [self layoutSubviews];
}

- (void)_dateButtonPressed:(id)sender {
    DateButton *dateButton = sender;
    NSDate *date = dateButton.date;
    if ([date isEqualToDate:self.selectedDate]) {
        // deselection..
        if ([self.delegate respondsToSelector:@selector(calendar:willDeselectDate:)] && ![self.delegate calendar:self willDeselectDate:date]) {
            return;
        }
//        date = nil;
    } else if ([self.delegate respondsToSelector:@selector(calendar:willSelectDate:)] && ![self.delegate calendar:self willSelectDate:date]) {
        return;
    }

    [self selectDate:date makeVisible:YES];
//    [self selectDate:date makeVisible:NO];
    [self.delegate calendar:self didSelectDate:date];
    [self setNeedsLayout];
}

#pragma mark - Theming getters/setters

- (void)setTitleFont:(UIFont *)font {
    self.titleLabel.font = font;
    self.prevButton.titleLabel.font = [font fontWithSize:font.pointSize-2];
    self.nextButton.titleLabel.font = [font fontWithSize:font.pointSize-2];
}
- (UIFont *)titleFont {
    return self.titleLabel.font;
}

- (void)setTitleColor:(UIColor *)color {
    self.titleLabel.textColor = color;
    [self.titleLabel.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.titleLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.titleLabel.layer setShadowOpacity:0.3];
    [self.titleLabel.layer setShadowRadius:0.7];
    
    //put here for fun
    [self.nextButton.titleLabel.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.nextButton.titleLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.nextButton.titleLabel.layer setShadowOpacity:0.3];
    [self.nextButton.titleLabel.layer setShadowRadius:0.7];
    
    [self.prevButton.titleLabel.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.prevButton.titleLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.prevButton.titleLabel.layer setShadowOpacity:0.3];
    [self.prevButton.titleLabel.layer setShadowRadius:0.7];
}
- (UIColor *)titleColor {
    return self.titleLabel.textColor;
}

- (void)setMonthButtonColor:(UIColor *)color {
    [self.prevButton setImage:[CKCalendarView _imageNamed:@"left_arrow.png" withColor:color] forState:UIControlStateNormal];
    [self.nextButton setImage:[CKCalendarView _imageNamed:@"right_arrow.png" withColor:color] forState:UIControlStateNormal];

}

- (void)setInnerBorderColor:(UIColor *)color {
    self.calendarContainer.layer.borderColor = color.CGColor;
}

- (void)setDayOfWeekFont:(UIFont *)font {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.font = font;
    }
}
- (UIFont *)dayOfWeekFont {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).font : nil;
}

- (void)setDayOfWeekTextColor:(UIColor *)color {
    for (UILabel *label in self.dayOfWeekLabels) {
        label.textColor = color;
    }
}
- (UIColor *)dayOfWeekTextColor {
    return (self.dayOfWeekLabels.count > 0) ? ((UILabel *)[self.dayOfWeekLabels lastObject]).textColor : nil;
}

- (void)setDayOfWeekBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor {
//    [self.daysHeader setColors:[NSArray arrayWithObjects:topColor, bottomColor, nil]];
}

- (void)setDateFont:(UIFont *)font {
    for (DateButton *dateButton in self.dateButtons) {
        dateButton.titleLabel.font = font;
        [dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    }
}
- (UIFont *)dateFont {
    return (self.dateButtons.count > 0) ? ((DateButton *)[self.dateButtons lastObject]).titleLabel.font : nil;
}

- (void)setDateBorderColor:(UIColor *)color {
    self.calendarContainer.backgroundColor = color;
}
- (UIColor *)dateBorderColor {
    return self.calendarContainer.backgroundColor;
}

#pragma mark - Calendar helpers

- (NSDate *)_firstDayOfMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.day = 1;
    return [self.calendar dateFromComponents:comps];
}

- (NSDate *)_firstDayOfNextMonthContainingDate:(NSDate *)date {
    NSDateComponents *comps = [self.calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    comps.day = 1;
    comps.month = comps.month + 1;
    return [self.calendar dateFromComponents:comps];
}

- (BOOL)dateIsInCurrentMonth:(NSDate *)date {
    return ([self _compareByMonth:date toDate:self.monthShowing] == NSOrderedSame);
}

- (NSComparisonResult)_compareByMonth:(NSDate *)date toDate:(NSDate *)otherDate {
    NSDateComponents *day = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date];
    NSDateComponents *day2 = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:otherDate];

    if (day.year < day2.year) {
        return NSOrderedAscending;
    } else if (day.year > day2.year) {
        return NSOrderedDescending;
    } else if (day.month < day2.month) {
        return NSOrderedAscending;
    } else if (day.month > day2.month) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSInteger)_placeInWeekForDate:(NSDate *)date {
    NSDateComponents *compsFirstDayInMonth = [self.calendar components:NSWeekdayCalendarUnit fromDate:date];
    return (compsFirstDayInMonth.weekday - 1 - self.calendar.firstWeekday + 8) % 7;
}

- (BOOL)_dateIsToday:(NSDate *)date {
    return [self date:[NSDate date] isSameDayAsDate:date];
}

- (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2 {
    // Both dates must be defined, or they're not the same
    if (date1 == nil || date2 == nil) {
        return NO;
    }

    NSDateComponents *day = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date1];
    NSDateComponents *day2 = [self.calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date2];
    return ([day2 day] == [day day] &&
            [day2 month] == [day month] &&
            [day2 year] == [day year] &&
            [day2 era] == [day era]);
}

- (NSInteger)_numberOfWeeksInMonthContainingDate:(NSDate *)date {
    return [self.calendar rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (NSDate *)_nextDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSDate *)_previousDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    return [self.calendar dateByAddingComponents:comps toDate:date options:0];
}

- (NSInteger)_numberOfDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSInteger startDay = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:startDate];
    NSInteger endDay = [self.calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:endDate];
    return endDay - startDay;
}

+ (UIImage *)_imageNamed:(NSString *)name withColor:(UIColor *)color {
    UIImage *img = [UIImage imageNamed:name];

    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];

    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);

    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);

    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return coloredImg;
}

#pragma mark - Kale's additional helpers

-(NSDate *)dateForLocationInView:(CGPoint)point {
    
    CGPoint aPoint = [self.calendarContainer convertPoint:point fromView:self];
    
    NSDate *date = nil;
    
    for (DateButton *aButton in self.dateButtons) {
        
        CGRect frame = aButton.frame;
        
        if (CGRectContainsPoint(frame, aPoint)) {
         
            NSLog(@"1. point: %f, %f", aPoint.x, aPoint.y);
            NSLog(@"2. frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
            NSLog(@"datebutton: %@", aButton.date);
            
            date = aButton.date;
        }
    }
    
    if (!self.onlyShowCurrentMonth && [self _compareByMonth:date toDate:self.monthShowing] != NSOrderedSame) {
     
        return nil;
    }
    
    return date;
}

-(CGRect)frameForDate:(NSDate *)date {
    
    for (DateButton *aButton in self.dateButtons) {
        
        if ([self date:aButton.date isSameDayAsDate:date]) {
            
            if (!self.onlyShowCurrentMonth && [self _compareByMonth:date toDate:self.monthShowing] != NSOrderedSame) {
                
            }
            
            return [self.calendarContainer convertRect:aButton.frame toView:self];
        }
    }
    
    return CGRectMake(0, 0, 0, 0);
}

-(CGPoint)centerPointForDate:(NSDate *)date {
    
    for (DateButton *aButton in self.dateButtons) {
        
        if ([self date:aButton.date isSameDayAsDate:date]) {
            
            if (!self.onlyShowCurrentMonth && [self _compareByMonth:date toDate:self.monthShowing] != NSOrderedSame) {
                
            }
            
            return [self.calendarContainer convertPoint:aButton.center toView:self];
        }
    }
    
    return CGPointMake(0, 0);
}

@end