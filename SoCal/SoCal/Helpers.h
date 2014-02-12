//
//  Helpers.h
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helpers : NSObject

+(UIFont *)Exo2Thin:(float)size;
+(UIFont *)Exo2Light:(float)size;
+(UIFont *)Exo2Regular:(float)size;
+(UIFont *)Exo2Medium:(float)size;
+(UIFont *)Exo2MediumItalic:(float)size;
+(UIFont *)Exo2Bold:(float)size;

+(UIColor *)softGreenColorWithAlpha:(float)alpha;
+(UIColor *)softRedColorWithAlpha:(float)alpha;
+(UIColor *)suriaOrangeColorWithAlpha:(float)alpha;
+(UIColor *)pmBlueColorWithAlpha:(float)alpha;
+(UIColor *)luncheonBlueColorWithAlpha:(float)alpha;
+(UIColor *)bondiBlueColorWithAlpha:(float)alpha;

+(void)setBorderToView:(UIView*)view borderColor:(UIColor*)color borderThickness:(float)thickness borderRadius:(float)radius;

+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)stringFromDate:(NSDate *)date;
+(NSString *)timeframeFromString:(NSString *)timeString;
+(NSDate *)dateWithNoTime:(NSDate *)date;
@end
