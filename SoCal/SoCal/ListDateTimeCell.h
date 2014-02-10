//
//  ListDateTimeCell.h
//  SoCal
//
//  Created by Rayser on 10/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListDateTimeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *mainBGView;
@property (nonatomic, weak) IBOutlet UIView *voteColorBar;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel;
@property (nonatomic, weak) IBOutlet UILabel *dayTimeLabel;

+(ListDateTimeCell *)newCell;
-(void)renderWithDate:(NSDate *)date andVote:(int)vote;

@end
