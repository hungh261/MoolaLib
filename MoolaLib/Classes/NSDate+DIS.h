//
//  NSDate+DIS.h
//  iOSUtility
//
//  Created by QuangPC on 2/19/14.
//  Copyright (c) 2014 DIS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (DIS)

/**
 *  Get local time zone string
 *
 *  @return eg: GMT+7
 */
+ (NSString *)localTimeZoneAbbreviation;
+ (NSDateFormatter *)dateFormatter;
- (NSDate *) toGlobalTime;
- (NSString *)stringWithDateFormat:(NSString *)dateFormat;


#pragma mark -
#pragma mark Relative date from current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

#pragma mark -
#pragma mark Compare Date
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isNextDayOfDateInUTC:(NSDate *)date;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isFirstDayOfMonth;

#pragma mark -
#pragma mark Adjust date
- (NSDate *)dateByAddingYears:(NSInteger)years;
- (NSDate *) dateByAddingQuarters:(NSInteger)quarters;
- (NSDate *) dateByAddingMonths:(NSInteger)months;
- (NSDate *) dateByAddingWeeks: (NSInteger)weeks;
- (NSDate *) dateBySubtractingWeeks: (NSInteger)weeks;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;
- (NSDate *) dateAtStartOfDayInUTC;
- (NSDate *) dateAtStartOfDayInTimeZone:(NSTimeZone *)timeZone;
- (NSDate *) dateAtEndOfDayInUTC;
- (NSDate *) dateAtEndOfDayInTimeZone:(NSTimeZone *)timeZone;
- (NSDate *) dateAtEndOfDay;
- (NSDate *) dateAtCurrentTime;
- (NSDate *) dateAtStartOfSubtractingMonths:(NSInteger)dMonths;
- (NSDate *) dateAtStartOfAddingMonths:(NSInteger)dMonths;
- (NSDate *) dateAtStartOfSubtractingQuarters:(NSInteger)dQuarters;
- (NSDate *) dateAtStartOfAddingQuarters:(NSInteger)dQuarters;
- (NSDate *) dateAtStartOfSubtractingYears:(NSInteger)dYears;
- (NSDate *) dateAtStartOfAddingYears:(NSInteger)dYears;
- (NSDate *) dateAtEndOfAddingMonths:(NSInteger)dMonths;
- (NSDate *) dateAtEndOfSubtractingMonths:(NSInteger)dMonths;
- (NSDate *) dateAtStartOfWeek;
- (NSDate *) dateAtStartOfMonth;
- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)year;

#pragma mark - Quarter
- (NSDate *)firstDayOfCurrentQuarter;

#pragma mark -
#pragma mark Different between date
- (NSUInteger)minutesBetweenDate:(NSDate *)dDate;
- (NSUInteger)hoursBetweenDate:(NSDate *)dDate;
- (NSUInteger)daysBetweenDate:(NSDate *)dDate;
- (NSInteger)durationByDaysFromDate:(NSDate *)dDate;
- (NSInteger)durationByDaysSinceDateIgnoreTime:(NSDate *)dDate;
- (double)weeksBetweenDate:(NSDate *)dDate;
- (NSUInteger)monthsBetweenDate:(NSDate *)dDate;
- (double)quartersBetweenDate:(NSDate *)dDate;
- (NSUInteger)yearsBetweenDate:(NSDate *)dDate;

#pragma mark -
#pragma mark convert string of date from current format date to another format date
+ (NSString *) convertFromStringDate:(NSString *)stringDate withFormat:(NSString *)currentFormatDate toFormat:(NSString *)expectFormatDate;
+ (NSString *) convertToStringFromDate:(NSDate *)date withFormat:(NSString *)formatDate inLocale:(NSLocale *)locale;
+ (NSString *) convertToStringFromDate:(NSDate *)date withFormat:(NSString *)formatDate;
+ (NSString *) convertToStringFromDateUTC:(NSDate *)date withFormat:(NSString *)formatDate;
+ (NSString *) convertToStringFromDateLocalTimeZone:(NSDate *)date withFormat:(NSString *)formatDate;
+ (NSDate *) convertToDateFromString:(NSString *)string withFormatDate:(NSString *)formatDate;

@end

@interface NSDate (NSNumber)

+ (instancetype)dateWithoutMiniseconds:(NSNumber *)number;
+ (instancetype)dateWithMiniseconds:(NSNumber *)number;
- (NSNumber *)toUnixTimeInMiniseconds;

@end

@interface NSDate (GetSpecificDate)

+ (NSDate *)ext_dateAtStartOfYear;
+ (NSDate *)ext_dateAtStartOfYearOfDate:(NSDate *)date;
- (NSDate *)ext_dateAtStartOfYear;

- (void)ext_startDateInMonth:(NSDate **)start endDateInMonth:(NSDate **)endDate;
- (void)ext_startDateInMonth:(NSDate **)start endDateInMonth:(NSDate **)endDate maximumEndDate:(NSDate *)maximumDate;

@end

