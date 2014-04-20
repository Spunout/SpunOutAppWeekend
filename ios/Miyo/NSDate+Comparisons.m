//
//  NSDate+Comparisons.m
//  Miyo
//
//  Created by Matt Donnelly on 16/02/2014.
//  Copyright (c) 2014 SpunOut. All rights reserved.
//

#import "NSDate+Comparisons.h"

@implementation NSDate (Comparisons)

- (BOOL)isToday
{
    if (!self) {
        return NO;
    }
    NSLog(@"current date: %f", [self timeIntervalSince1970]);
    
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    return [today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
    [today era] == [otherDay era];

}

- (BOOL)isNewWeek
{
    if (!self) {
        return NO;
    }

    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear
                                                                       fromDate:self];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear
                                                                        fromDate:[NSDate date]];

    return dateComponents.era == todayComponents.era && dateComponents.yearForWeekOfYear == todayComponents.yearForWeekOfYear && dateComponents.weekOfYear != todayComponents.weekOfYear;
}

@end
