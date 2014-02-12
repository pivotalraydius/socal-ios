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

-(void) setupUI {

    [self.btnSelection setTitle:@"o" forState:UIControlStateSelected];
    [self.btnSelection setTitle:@"" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self.btnSelection setSelected:selected];

    // Configure the view for the selected state
}

-(void)renderCellWithData:(NSDictionary*)data {

    NSString *strName = [data objectForKey:@"name"];
    NSString *strEmail = [data objectForKey:@"email"];
    NSNumber *selected = [data objectForKey:@"selected"];
    [self setupUI];
    [self.lblName setText:strName];
    [self.lblEmail setText:strEmail];
    
    if ([selected intValue] == 1) {
    
        [self.btnSelection setSelected:YES];
        [self.btnSelection setTitle:@"o" forState:UIControlStateSelected];
    }
    else {
    
        [self.btnSelection setSelected:NO];
        [self.btnSelection setTitle:@"" forState:UIControlStateNormal];
    }
    

}

@end