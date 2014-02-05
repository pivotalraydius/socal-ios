//
//  PlaceSearchCell.m
//  SoCal
//
//  Created by Rayser on 5/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "PlaceSearchCell.h"

@implementation PlaceSearchCell

+(PlaceSearchCell *)newCell {
    
    PlaceSearchCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PlaceSearchCell"
                                                               owner:nil
                                                             options:nil] objectAtIndex:0];
    
    return cell;
}

@end
