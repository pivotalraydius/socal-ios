//
//  ContactCell.h
//  SoCal
//
//  Created by Rayser on 12/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell
{

}

@property (nonatomic, strong) NSDictionary* data;
@property (nonatomic, weak) id parentVC;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblEmail;
@property (nonatomic, weak) IBOutlet UIButton *btnSelection;

+(ContactCell *)newContactCell;
-(void)setupUI;
-(void)renderCellWithData:(NSDictionary*)data;
//-(void)updateCellWithTime:(NSDate *)date;

@end
