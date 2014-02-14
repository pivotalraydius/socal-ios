//
//  SummaryDateTimeCell.h
//  SoCal
//
//  Created by Rayser on 10/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryDateTimeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *mainBGView;
@property (nonatomic, weak) IBOutlet UIView *yesFrameView;
@property (nonatomic, weak) IBOutlet UIView *noFrameView;
@property (nonatomic, weak) IBOutlet UIView *maybeFrameView;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel;

@property (nonatomic, weak) IBOutlet UILabel *starLabel;

@property (nonatomic, weak) IBOutlet UILabel *countLabel;

+(SummaryDateTimeCell *)newCell;
-(void)renderWithDate:(NSDate *)date andVotesYes:(NSInteger)yesVotes no:(NSInteger)noVotes Maybe:(NSInteger)maybeVotes;

@end
