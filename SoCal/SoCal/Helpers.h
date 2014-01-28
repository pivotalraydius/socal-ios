//
//  Helpers.h
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject

+(UIColor *)suriaOrangeColorWithAlpha:(float)alpha;
+(UIColor *)luncheonBlueColorWithAlpha:(float)alpha;
+(UIColor *)bondiBlueColorWithAlpha:(float)alpha;

+(void)setBorderToView:(UIView*)view borderColor:(UIColor*)color borderThickness:(float)thickness borderRadius:(float)radius;

@end
