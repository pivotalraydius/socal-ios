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

@property (nonatomic, weak) id parentVC;
@property (nonatomic, weak) IBOutlet UILabel *lblCheck;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblEmail;

+(ContactCell *)newContactCell;
-(void)setupUI;
-(void)renderCellWithData:(NSDictionary*)data;

@end
