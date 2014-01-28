//
//  ComposeDateTimeCell.m
//  SoCal
//
//  Created by Rayser on 27/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "ComposeDateTimeCell.h"
#import "ComposeVC.h"

@implementation ComposeDateTimeCell

+ (ComposeDateTimeCell *)newComposeDateTimeCell {
    
    ComposeDateTimeCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ComposeDateTimeCell"
                                                               owner:nil
                                                             options:nil] objectAtIndex:0];
    
    [cell setupUI];
    
    return cell;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
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
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.btnDeleteCell.layer setCornerRadius:self.btnDeleteCell.frame.size.height/2];
    [self.btnAcceptTime.layer setCornerRadius:self.btnAcceptTime.frame.size.height/2];
}

-(void)renderCellDataWithDate:(NSDate *)date andIndexPathRow:(NSInteger)row {
    
    self.indexPathRow = row;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, EEEE"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *displayString = dateString;
    
    [self.lblEventDateTime setText:displayString];
    
    if (self.indexPathRow % 2 == 0) {
        
        //shift left
        NSLog(@"cell %i left", self.indexPathRow);
        [self.mainView setFrame:CGRectMake(0, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    }
    else {
        
        //shift right
        NSLog(@"cell %i right", self.indexPathRow);
        [self.mainView setFrame:CGRectMake(25, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    }
    
    NSLog(@"mainView: %@", self.mainView);
}

-(void)updateCellWithTime:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM d, EEEE, hh:mm a"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *displayString = dateString;
    
    [self.lblEventDateTime setText:displayString];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"hh:mm a"];
    
    NSString *dateString2 = [dateFormatter2 stringFromDate:date];
    
    NSString *displayString2 = dateString2;
    
    [self.lblEventEditTime setText:displayString2];
}

-(IBAction)deleteCellButton {
    
    [(ComposeVC *)self.parentVC deleteCellAtIndexPathRow:self.indexPathRow];
}

-(IBAction)acceptTimeButton {
    
    [(ComposeVC *)self.parentVC closeTimePanelForCellAtIndexPathRow:self.indexPathRow];
}

-(IBAction)editTimeButton {
    
    [(ComposeVC *)self.parentVC editTimeForCellAtIndexPathRow:self.indexPathRow];
}

@end
