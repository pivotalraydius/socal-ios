//
//  ContactCell.m
//  SoCal
//
//  Created by Rayser on 12/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

+ (ContactCell *)newContactCell {
    
    ContactCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell"
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

- (void)prepareForReuse {

    [self setSelected:NO animated:NO];
}

-(void) setupUI {
    
    [self.lblName setFont:[Helpers Exo2Regular:13.0]];
    [self.lblEmail setFont:[Helpers Exo2Regular:11.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) return;
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self reloadDataWithSelectedState:selected];
}

-(void)renderCellWithData:(NSDictionary*)data {

    NSString *strName = [data objectForKey:@"name"];
    NSString *strEmail = [data objectForKey:@"email"];
    NSNumber *selected = [data objectForKey:@"selected"];
    [self.lblName setText:strName];
    [self.lblEmail setText:strEmail];
    
    NSLog(@"%@ : selected : %d", strName, selected.intValue);
    [self reloadDataWithSelectedState:[selected boolValue]];
}

-(void)reloadDataWithSelectedState: (BOOL) selected {

    if (selected) {
        [self setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.lblCheck setText:@"\u2714"]; //u2705
        NSLog(@"selected");
    }
    else {
        
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self.lblCheck setText:@""]; //u2B1C
        NSLog(@"NOT selected");
    }
    
    /*
     selected \u2705
     unselected \u2B1C
     
     @"\u2611", @"\u2B1C", @"\u2705", @"\u26AB", @"\u26AA", @"\u2714", @"\U0001F44D", @"\U0001F44E"

     */
}

@end
