//
//  Helpers.m
//  SoCal
//
//  Created by Rayser on 24/1/14.
//  Copyright (c) 2014 HereNow. All rights reserved.
//

#import "Helpers.h"

#define RD_ONE_YEAR_IN_SECS   31556926
#define RD_ONE_MONTH_IN_SECS  2629743
#define RD_ONE_DAY_IN_SECS    86400
#define RD_ONE_HOUR_IN_SECS   3600
#define RD_ONE_MINUTE_IN_SECS 60

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

+(NSString *)timeframeFromString:(NSString *)timeString {
    
    NSDate *currentDate = [NSDate date];
    NSDate *previousDate = [Helpers dateFromString:timeString];
    
    NSTimeInterval timeSincePosted = [currentDate timeIntervalSinceDate:previousDate];
    NSString *timeStringSincePosted = nil;
    
    if (timeSincePosted > RD_ONE_YEAR_IN_SECS) {
        timeStringSincePosted = [NSString stringWithFormat:@"A long time ago"];
    }
    else if (timeSincePosted > RD_ONE_MONTH_IN_SECS) {
        int numMonths = floor(timeSincePosted/RD_ONE_MONTH_IN_SECS);
        if (numMonths == 1)
            timeStringSincePosted = [NSString stringWithFormat:@"%d mth ago", numMonths];
        else
            timeStringSincePosted = [NSString stringWithFormat:@"%d mths ago", numMonths];
    }
    else if (timeSincePosted > RD_ONE_DAY_IN_SECS) {
        int numDays = floor(timeSincePosted/RD_ONE_DAY_IN_SECS);
        if (numDays == 1)
            timeStringSincePosted = [NSString stringWithFormat:@"%d day ago", numDays];
        else
            timeStringSincePosted = [NSString stringWithFormat:@"%d days ago", numDays];
    }
    else if (timeSincePosted > RD_ONE_HOUR_IN_SECS) {
        int numHours = floor(timeSincePosted/RD_ONE_HOUR_IN_SECS);
        if (numHours == 1)
            timeStringSincePosted = [NSString stringWithFormat:@"%d hr ago", numHours];
        else
            timeStringSincePosted = [NSString stringWithFormat:@"%d hrs ago", numHours];
    }
    else if (timeSincePosted >= 0) {
        int numMinutes = floor(timeSincePosted/RD_ONE_MINUTE_IN_SECS);
        if (numMinutes == 1)
            timeStringSincePosted = [NSString stringWithFormat:@"%d min ago", numMinutes];
        else if (numMinutes >= 0 && numMinutes < 1)
            timeStringSincePosted = @"just now";
        else
            timeStringSincePosted = [NSString stringWithFormat:@"%d mins ago", numMinutes];
    }
    else {
        timeStringSincePosted = @"";
    }
    
    return timeStringSincePosted;
    
    return @"";
}

@end
