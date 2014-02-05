//
//  Helpers.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+(UIColor *)suriaOrangeColorWithAlpha:(float)alpha {
    
    return [UIColor colorWithRed:255.0/255.0 green:175.0/255.0 blue:55.0/255.0 alpha:alpha];
}

+(UIColor *)pmBlueColorWithAlpha:(float)alpha {
    
    return [UIColor colorWithRed:121.0/255.0 green:150.0/255.0 blue:179.0/255.0 alpha:alpha];
}

+(UIColor *)luncheonBlueColorWithAlpha:(float)alpha {
    
    return [UIColor colorWithRed:127.0/255.0 green:209.0/255.0 blue:216.0/255.0 alpha:alpha];
}

+(UIColor *)bondiBlueColorWithAlpha:(float)alpha {
    
    return [UIColor colorWithRed:0.0/255.0 green:163.0/255.0 blue:178.0/255.0 alpha:alpha];
}

+(void)setBorderToView:(UIView*)view borderColor:(UIColor*)color borderThickness:(float)thickness borderRadius:(float)radius {
    
    if (color) [view.layer setBorderColor:color.CGColor];
    if (thickness>0) [view.layer setBorderWidth:thickness];
    if (radius>0) [view.layer setCornerRadius:radius];
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    
    if (!dateString) return nil;
    if ([dateString hasSuffix:@"Z"]) {
        dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"-0000"];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    return [formatter dateFromString:dateString];
}

+(NSString *)stringFromDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    return [formatter stringFromDate:date];
}

@end
