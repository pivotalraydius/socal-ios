//
//  PostCell.h
//  SoCal
//
//  Created by Rayser on 6/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *speechBubbleView;
@property (nonatomic, weak) IBOutlet UIView *speechBubbleBox;
@property (nonatomic, weak) IBOutlet UIImageView *speechBubbleTail;
@property (nonatomic, weak) IBOutlet UIImageView *speechBubbleTailSelf;
@property (nonatomic, weak) IBOutlet UILabel *contentLabel;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

+(PostCell *)newPostCell;

-(void)setLeftSide;
-(void)setRightSide;

@end
