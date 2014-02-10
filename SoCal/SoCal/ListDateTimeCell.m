//
//  ListDateTimeCell.m
//  SoCal
//
//  Created by Rayser on 10/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "ListDateTimeCell.h"

#define VOTE_MAYBE 0
#define VOTE_YES   1
#define VOTE_NO    2

@implementation ListDateTimeCell

+(ListDateTimeCell *)newCell {
    
    ListDateTimeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ListDateTimeCell"
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
}

-(void)renderWithDate:(NSDate *)date andVote:(int)vote {
    
    if (vote == VOTE_YES) {
        [self.voteColorBar setBackgroundColor:[Helpers softGreenColorWithAlpha:1.0]];
    }
    else if (vote == VOTE_NO) {
        [self.voteColorBar setBackgroundColor:[Helpers softRedColorWithAlpha:1.0]];
    }
    else if (vote == VOTE_MAYBE) {
        [self.voteColorBar setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    }
    
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
    [self.dayTimeLabel setText:dayTimeStr];
    
    if ([dayTimeStr hasSuffix:@"am"]) {
        [self.mainBGView setBackgroundColor:[Helpers suriaOrangeColorWithAlpha:1.0]];
    }
    else {
        [self.mainBGView setBackgroundColor:[Helpers pmBlueColorWithAlpha:1.0]];
    }
}

@end
