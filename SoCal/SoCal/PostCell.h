//
//  PostCell.h
//  SoCal
//
//  Created by Rayser on 6/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *bubbleImageView;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

+(PostCell *)newPostCell;

-(void)setLeftSide;
-(void)setRightSide;

@end
