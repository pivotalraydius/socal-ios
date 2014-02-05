//
//  PlaceSearchCell.h
//  SoCal
//
//  Created by Rayser on 5/2/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceSearchCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblPlaceName;
@property (nonatomic, weak) IBOutlet UILabel *lblPlaceAddress;

+(PlaceSearchCell *)newCell;

@end
