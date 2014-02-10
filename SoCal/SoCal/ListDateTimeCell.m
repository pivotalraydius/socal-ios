//
//  ListDateTimeCell.m
//  SoCal
//
//  Created by Rayser on 10/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "ListDateTimeCell.h"

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
    
}

-(void)renderWithDate:(NSDate *)date andVote:(int)vote {
    
}

@end
