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
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                                       fromDate:self];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                                        fromDate:[NSDate date]];

    return dateComponents.era == todayComponents.era
    && dateComponents.year == todayComponents.year
    && dateComponents.month == todayComponents.month
    && dateComponents.day == todayComponents.day;
}

- (BOOL)isNewWeek
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear
                                                                       fromDate:self];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear
                                                                        fromDate:[NSDate date]];

    return dateComponents.era == todayComponents.era
    && dateComponents.year == todayComponents.year
    && dateComponents.month == todayComponents.month;
}

@end
