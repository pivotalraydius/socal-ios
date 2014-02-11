//
//  SummaryDateTimeCell.m
//  SoCal
//
//  Created by Rayser on 10/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "SummaryDateTimeCell.h"

#define VOTE_MAYBE 0
#define VOTE_YES   1
#define VOTE_NO    2

#define TOTAL_WIDTH_YESNOMAYBE 130

@implementation SummaryDateTimeCell

+(SummaryDateTimeCell *)newCell {
    
    SummaryDateTimeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SummaryDateTimeCell"
                                                    owner:nil
                                                  options:nil] objectAtIndex:0];
    
    [cell setupUI];
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupUI {
    
    [Helpers setBorderToView:self.dateLabel borderColor:[UIColor clearColor] borderThickness:0.0 borderRadius:self.dateLabel.frame.size.width/2];
    
    [self.starLabel setHidden:YES];
}

-(void)renderWithDate:(NSDate *)date andVotesYes:(NSInteger)yesVotes no:(NSInteger)noVotes Maybe:(NSInteger)maybeVotes {
    
    NSString *dateStr = @"";
    NSString *monthStr = @"";
    NSString *dayTimeStr = @"";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setAMSymbol:@"am"];
    [df setPMSymbol:@"pm"];
    
    [df setDateFormat:@"dd"];
    
    dateStr = [NSString stringWithFormat:@"%@",
               [df stringFromDate:date]];
    
    [df setDateFormat:@"MMMM"];
    
    monthStr = [NSString stringWithFormat:@"%@",
                [df stringFromDate:date]];
    
    [df setDateFormat:@"eeee, hh:mm a"];
    
    dayTimeStr = [NSString stringWithFormat:@"%@",
                  [df stringFromDate:date]];
    
    [self.dateLabel setText:dateStr];
    [self.monthLabel setText:monthStr];
    
    if ([dayTimeStr hasSuffix:@"am"]) {
        [self.mainBGView setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    }
    else {
        [self.mainBGView setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
    }
    
    //count votes and display frames accordingly
    int totalCount = yesVotes + noVotes + maybeVotes;
//    int totalCount = 10;
    
    float yesWidth = 0.0;
    float noWidth = 0.0;
//    float maybeWidth = 0.0;
    
    if (totalCount == 0) {
        
    }
    else {
        yesWidth = yesVotes * TOTAL_WIDTH_YESNOMAYBE/totalCount;
        noWidth = noVotes * TOTAL_WIDTH_YESNOMAYBE/totalCount;
//        maybeWidth = maybeVotes * TOTAL_WIDTH_YESNOMAYBE/totalCount;
    }
    
    float yesOriginX = self.yesFrameView.frame.origin.x;
    float noOriginX = yesOriginX + yesWidth;
//    float maybeOriginX = noOriginX + noWidth;
    
    [self.yesFrameView setFrame:CGRectMake(yesOriginX, self.yesFrameView.frame.origin.y, yesWidth, self.yesFrameView.frame.size.height)];
    [self.noFrameView setFrame:CGRectMake(noOriginX, self.noFrameView.frame.origin.y, noWidth, self.noFrameView.frame.size.height)];
    [self.maybeFrameView setFrame:CGRectMake(yesOriginX, self.maybeFrameView.frame.origin.y, TOTAL_WIDTH_YESNOMAYBE, self.maybeFrameView.frame.size.height)];
}

@end
