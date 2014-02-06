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
    
}

-(void)setLeftSide {
    
    [self.bubbleImageView setFrame:CGRectMake(0, 0, self.bubbleImageView.frame.size.width, self.bubbleImageView.frame.size.height)];
    [self.bubbleImageView setImage:[UIImage imageNamed:@"bubble.png"]];
    
    [self.contentLabel setFrame:CGRectMake(18, 4, self.contentLabel.frame.size.width, self.contentLabel.frame.size.height)];
    [self.timeLabel setFrame:CGRectMake(159, 39, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height)];
    [self.timeLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.authorLabel setFrame:CGRectMake(18, 39, self.authorLabel.frame.size.width, self.authorLabel.frame.size.height)];
    [self.authorLabel setHidden:NO];
}

-(void)setRightSide {
    
    [self.bubbleImageView setFrame:CGRectMake(48, 0, self.frame.size.width, self.frame.size.height)];
    [self.bubbleImageView setImage:[UIImage imageWithCGImage:self.bubbleImageView.image.CGImage scale:self.bubbleImageView.image.scale orientation: UIImageOrientationUpMirrored]];
    
    [self.contentLabel setFrame:CGRectMake(60, 4, self.contentLabel.frame.size.width, self.contentLabel.frame.size.height)];
    [self.timeLabel setFrame:CGRectMake(49, 39, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height)];
    [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
    
    [self.authorLabel setHidden:YES];
}

@end
