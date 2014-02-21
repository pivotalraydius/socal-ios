//
//  PostCell.m
//  SoCal
//
//  Created by Rayser on 6/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

+(PostCell *)newPostCell {
    
    PostCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PostCell"
                                                               owner:nil
                                                             options:nil] objectAtIndex:0];
    
    [cell setupUI];
    
    return cell;
}

-(void)setupUI {
    
    [self.contentLabel setFont:[Helpers Exo2Regular:14.0]];
    [self.authorLabel setFont:[Helpers Exo2Regular:12.0]];
    [self.timeLabel setFont:[Helpers Exo2Regular:12.0]];
    
    [self.speechBubbleBox.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.speechBubbleBox.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.speechBubbleBox.layer setShadowOpacity:0.3];
    [self.speechBubbleBox.layer setShadowRadius:0.7];
    
    [self.speechBubbleTail.layer setShadowOffset:CGSizeMake(1.3,1.3)];
    [self.speechBubbleTail.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.speechBubbleTail.layer setShadowOpacity:0.3];
    [self.speechBubbleTail.layer setShadowRadius:0.9];
    
    [self.speechBubbleTailSelf.layer setShadowOffset:CGSizeMake(1.3,1.3)];
    [self.speechBubbleTailSelf.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.speechBubbleTailSelf.layer setShadowOpacity:0.3];
    [self.speechBubbleTailSelf.layer setShadowRadius:0.9];
    
    [self.authorLabel.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.authorLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.authorLabel.layer setShadowOpacity:0.3];
    [self.authorLabel.layer setShadowRadius:0.7];
    
    [self.timeLabel.layer setShadowOffset:CGSizeMake(0.8,1.0)];
    [self.timeLabel.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.timeLabel.layer setShadowOpacity:0.3];
    [self.timeLabel.layer setShadowRadius:0.7];
}

-(void)setLeftSide {
    
    [self.speechBubbleView setFrame:CGRectMake(3, 0, self.speechBubbleView.frame.size.width, self.speechBubbleView.frame.size.height)];
    
    [self.speechBubbleTail setHidden:NO];
    [self.speechBubbleTailSelf setHidden:YES];
    
    [self.contentLabel setFrame:CGRectMake(18, 4, self.contentLabel.frame.size.width, self.contentLabel.frame.size.height)];
    [self.timeLabel setFrame:CGRectMake(159, 39, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height)];
    [self.timeLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.authorLabel setFrame:CGRectMake(18, 39, self.authorLabel.frame.size.width, self.authorLabel.frame.size.height)];
    [self.authorLabel setHidden:NO];
}

-(void)setRightSide {
    
    [self.speechBubbleView setFrame:CGRectMake(44, 0, self.speechBubbleView.frame.size.width, self.speechBubbleView.frame.size.height)];
    
    [self.speechBubbleTail setHidden:YES];
    [self.speechBubbleTailSelf setHidden:NO];
    
    [self.contentLabel setFrame:CGRectMake(60, 4, self.contentLabel.frame.size.width, self.contentLabel.frame.size.height)];
    [self.timeLabel setFrame:CGRectMake(49, 39, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height)];
    [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.authorLabel setHidden:YES];
}

@end
