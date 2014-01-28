//
//  ComposeDateTimeCell.h
//  SoCal
//
//  Created by Rayser on 27/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeDateTimeCell : UITableViewCell

@property (nonatomic, weak) id parentVC;
@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIView *barBGView;
@property (nonatomic, weak) IBOutlet UILabel *lblTimeTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *lblEventDateTime;
@property (nonatomic, weak) IBOutlet UILabel *lblEventEditTime;
@property (nonatomic, weak) IBOutlet UIButton *btnDeleteCell;
@property (nonatomic, weak) IBOutlet UIButton *btnAcceptTime;
@property (nonatomic, weak) IBOutlet UIButton *btnEditTime;

@property NSInteger indexPathRow;

+(ComposeDateTimeCell *)newComposeDateTimeCell;
-(void)renderCellDataWithDate:(NSDate *)date andIndexPathRow:(NSInteger)row;
-(void)updateCellWithTime:(NSDate *)date;

@end
