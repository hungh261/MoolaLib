//
//  NSDate+DIS.m
//  iOSUtility
//
//  Created by QuangPC on 2/19/14.
//  Copyright (c) 2014 DIS. All rights reserved.
//

#import "NSDate+DIS.h"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (DIS)

#pragma mark -
#pragma mark DIS
+ (NSString *)localTimeZoneAbbreviation {
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    NSString *localTimeZoneAbbreviation = [localTimeZone abbreviation];
    return localTimeZoneAbbreviation;
}

- (NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

- (NSString *)stringWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:dateFormat];
    return [fm stringFromDate:self];
}

#pragma mark -
#pragma mark Relative date from current date
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
	NSDate *newDate = [NSDate dateWithTimeInterval:D_DAY * days sinceDate:[NSDate date]];
	return newDate;
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
	NSDate *newDate = [NSDate dateWithTimeInterval:- D_DAY * days sinceDate:[NSDate date]];
	return newDate;
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
	NSDate *newDate = [NSDate dateWithTimeInterval:D_HOUR * dHours sinceDate:[NSDate date]];
	return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
	NSDate *newDate = [NSDate dateWithTimeInterval:- D_HOUR * dHours sinceDate:[NSDate date]];
	return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
	NSDate *newDate = [NSDate dateWithTimeInterval:D_MINUTE * dMinutes sinceDate:[NSDate date]];
	return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
	NSDate *newDate = [NSDate dateWithTimeInterval:- D_MINUTE * dMinutes sinceDate:[NSDate date]];
	return newDate;
}

#pragma mark -
#pragma mark Compare Date
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    if (!aDate) {
        return NO;
    }
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]) &&
			([components1 day] == [components2 day]));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isNextDayOfDateInUTC:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDateComponents *comp1 = [calendar components:NSCalendarUnitDay fromDate:self];
    NSDateComponents *comp2 = [calendar components:NSCalendarUnitDay fromDate:date];
    return comp1.day == comp2.day + 1;
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if ([components1 weekOfMonth] != [components2 weekOfMonth]) return NO;
    
	// Must have a time interval under 1 week. Thanks @aclark
	return (ABS([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL)isSameMonthAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    return [components1 month] == [components2 month];
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSDate *newDate = [NSDate dateWithTimeInterval:D_WEEK sinceDate:[NSDate date]];
	return [self isSameYearAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSDate *newDate = [NSDate dateWithTimeInterval:- D_WEEK sinceDate:[NSDate date]];
	return [self isSameYearAsDate:newDate];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
	return ([components1 year] == [components2 year]);
}

- (BOOL) isThisYear
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return ([components1 year] == [components2 year]);
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
	return ([components1 year] == ([components2 year] + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    
	return ([components1 year] == ([components2 year] - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
    return [self compare:aDate] == NSOrderedAscending;
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return [self compare:aDate] == NSOrderedDescending;
}

- (BOOL)isFirstDayOfMonth {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day == 1;
}


#pragma mark -
#pragma mark Adjust date

- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    components.year += years; // year is automatic handle!!!
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)dateByAddingQuarters:(NSInteger)quarters {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    components.quarter += quarters; // year is automatic handle!!!
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    components.month += months; // year is automatic handle!!!
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks{
    NSDate *newDate = [NSDate dateWithTimeInterval:D_WEEK * weeks sinceDate:self];
    return newDate;
}

- (NSDate *)dateBySubtractingWeeks:(NSInteger)weeks{
    return [self dateByAddingWeeks: (weeks * -1)];
}
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
	NSDate *newDate = [NSDate dateWithTimeInterval:D_DAY * dDays sinceDate:self];
	return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
	NSDate *newDate = [NSDate dateWithTimeInterval:D_HOUR * dHours sinceDate:self];
	return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    NSInteger a = -1 * dHours;
	return [self dateByAddingHours: a];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
	NSDate *newDate = [NSDate dateWithTimeInterval:D_MINUTE * dMinutes sinceDate:self];
	return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
	return [CURRENT_CALENDAR dateFromComponents:components];
}
- (NSDate *)dateAtCurrentTime
{
    NSDateComponents *componentsOfCurrentDate = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:[NSDate date]];
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [components setHour:componentsOfCurrentDate.hour];
    [components setMinute:componentsOfCurrentDate.minute];
    [components setSecond:componentsOfCurrentDate.second];
    [components setNanosecond:componentsOfCurrentDate.nanosecond];
    return [CURRENT_CALENDAR dateFromComponents:components];
}
- (NSDate *)dateAtStartOfDayInUTC
{
    return [self dateAtStartOfDayInTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
}

- (NSDate *)dateAtStartOfDayInTimeZone:(NSTimeZone *)timeZone
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:timeZone];
    NSDateComponents *components = [calendar components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAtEndOfDayInUTC
{
    return [self dateAtEndOfDayInTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
}

- (NSDate *)dateAtEndOfDayInTimeZone:(NSTimeZone *)timeZone
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:timeZone];
    NSDateComponents *components = [calendar components:DATE_COMPONENTS fromDate:self];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    [components setNanosecond:(1-1/pow(10, 9))];
    return [calendar dateFromComponents:components];
}

+ (void)zeroOutTimeComponents:(NSDateComponents **)components
{
    [*components setHour:0];
    [*components setMinute:0];
    [*components setSecond:0];
    [*components setNanosecond:0];
}
- (NSDate *) dateAtEndOfDay
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    [components setNanosecond:(1-1/pow(10, 9))];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateAtStartOfSubtractingMonths:(NSInteger)dMonths
{
    return [self dateAtStartOfAddingMonths:-dMonths];
}
- (NSDate *) dateAtStartOfAddingMonths:(NSInteger)dMonths
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    components.day = 1;
    components.month += dMonths; // year is automatic handle!!!
    return [CURRENT_CALENDAR dateFromComponents:components];
}
- (NSDate *) dateAtStartOfSubtractingQuarters:(NSInteger)dQuarters
{
    return [self dateAtStartOfAddingQuarters:-dQuarters];
}
- (NSDate *) dateAtStartOfAddingQuarters:(NSInteger)dQuarters
{
    NSDate * newDate = [self firstDayOfCurrentQuarter];
    return [newDate dateAtStartOfAddingMonths:dQuarters * 3];
}
- (NSDate *) dateAtStartOfSubtractingYears:(NSInteger)dYears
{
    return [self dateAtStartOfAddingYears:-dYears];
}
- (NSDate *) dateAtStartOfAddingYears:(NSInteger)dYears
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    components.month = 1;
    components.day = 1;
    components.year += dYears;
    return [CURRENT_CALENDAR dateFromComponents:components];
}
- (NSDate *)dateAtEndOfAddingMonths:(NSInteger)dMonths{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    components.month += dMonths; // year is automatic handle!!!
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateFromComponents:components];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    components.day = range.length;
    return [CURRENT_CALENDAR dateFromComponents:components];
}
- (NSDate *)dateAtEndOfSubtractingMonths:(NSInteger)dMonths{
    return [self dateAtEndOfAddingMonths:-dMonths];
}
- (NSDate *)dateAtStartOfWeek{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    NSInteger dayInWeek  = [components weekday];
    components.day = components.day - (dayInWeek - 2);
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)dateAtStartOfMonth {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    [NSDate zeroOutTimeComponents:&components];
    components.day = 1;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSInteger)day
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}
- (NSInteger)month
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger)year
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

#pragma mark - Quarter
- (NSDate *)firstDayOfCurrentQuarter
{
    NSCalendar *gregorianCalendar = CURRENT_CALENDAR;
    NSDateComponents *components = [gregorianCalendar components:DATE_COMPONENTS fromDate:self];
    
    NSInteger quarterNumber = floor( ( components.month - 1 ) / 3 ) + 1;
    
    NSInteger firstMonthOfQuarter = ( quarterNumber - 1 ) * 3 + 1;
    [components setMonth:firstMonthOfQuarter];
    [components setDay:1];
    
    // Zero out the time components so we get midnight.
    [NSDate zeroOutTimeComponents:&components];
    return [gregorianCalendar dateFromComponents:components];
}

#pragma mark -
#pragma mark Different between date
- (NSUInteger)minutesBetweenDate:(NSDate *)dDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:dDate];
    NSInteger dif = (NSInteger) (ti / D_MINUTE);
    return ABS(dif);
}
- (NSUInteger)hoursBetweenDate:(NSDate *)dDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:dDate];
    NSInteger dif = (NSInteger) (ti / D_HOUR);
    return ABS(dif);
}
- (NSUInteger)daysBetweenDate:(NSDate *)dDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:dDate];
    NSInteger dif = (NSInteger) (ti / D_DAY);
    return ABS(dif);
}

- (NSInteger)durationByDaysFromDate:(NSDate *)dDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:dDate];
    NSInteger dif = (NSInteger) (ti / D_DAY);
    return dif;
}

- (NSInteger)durationByDaysSinceDateIgnoreTime:(NSDate *)dDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:dDate];
    NSDate *date1 = [calendar dateFromComponents:components1];
    NSDate *date2 = [calendar dateFromComponents:components2];
    return [date1 durationByDaysFromDate:date2];
}

- (double)weeksBetweenDate:(NSDate *)dDate {
    return (double)[self daysBetweenDate:dDate] / 7.0;
}

- (NSUInteger)monthsBetweenDate:(NSDate *)dDate {
    NSUInteger year1 = [CURRENT_CALENDAR component:NSCalendarUnitYear fromDate:self];
    NSUInteger year2 = [CURRENT_CALENDAR component:NSCalendarUnitYear fromDate:dDate];
    NSUInteger month1 = [CURRENT_CALENDAR component:NSCalendarUnitMonth fromDate:self];
    NSUInteger month2 = [CURRENT_CALENDAR component:NSCalendarUnitMonth fromDate:dDate];
    NSInteger value = 12 * (year1 - year2) + (month1 - month2);
    return labs(value);
}

- (double)quartersBetweenDate:(NSDate *)dDate {
    NSInteger year1 = [CURRENT_CALENDAR component:NSCalendarUnitYear fromDate:self];
    NSInteger year2 = [CURRENT_CALENDAR component:NSCalendarUnitYear fromDate:dDate];
    NSInteger month1 = [CURRENT_CALENDAR component:NSCalendarUnitMonth fromDate:self];
    NSInteger month2 = [CURRENT_CALENDAR component:NSCalendarUnitMonth fromDate:dDate];
    double value = 4 * (year1 - year2) + (month1 - month2)/3;
    return fabs(value);
}

- (NSUInteger)yearsBetweenDate:(NSDate *)dDate {
    NSUInteger year1 = [CURRENT_CALENDAR component:NSCalendarUnitYear fromDate:self];
    NSUInteger year2 = [CURRENT_CALENDAR component:NSCalendarUnitYear fromDate:dDate];
    NSInteger value = year1 - year2;
    return labs(value);
}

static NSDateFormatter * dateFormatter;
+ (NSDateFormatter *)dateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}
+ (NSString *) convertFromStringDate:(NSString *)stringDate withFormat:(NSString *)currentFormatDate toFormat:(NSString *)expectFormatDate {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:currentFormatDate];
    NSDate *date = [dateFormatter dateFromString:stringDate];
    
    [dateFormatter setDateFormat:expectFormatDate];
    return [dateFormatter stringFromDate:date];
}
static NSDateFormatter * localDateFormatter;
+ (NSString *) convertToStringFromDate:(NSDate *)date withFormat:(NSString *)formatDate inLocale:(NSLocale *)locale
{
    if (!localDateFormatter) {
        localDateFormatter = [[NSDateFormatter alloc] init];
    }
    [localDateFormatter setLocale:locale];
    [localDateFormatter setDateFormat:formatDate];
    return [localDateFormatter stringFromDate:date];
}

+ (NSString *) convertToStringFromDate:(NSDate *)date withFormat:(NSString *)formatDate {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formatDate];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) convertToStringFromDateUTC:(NSDate *)date withFormat:(NSString *)formatDate {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formatDate];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) convertToStringFromDateLocalTimeZone:(NSDate *)date withFormat:(NSString *)formatDate{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formatDate];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *) convertToDateFromString:(NSString *)string withFormatDate:(NSString *)formatDate {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formatDate];
    NSDate *dateFromString;
    dateFromString = [dateFormatter dateFromString:string];
    
    return dateFromString;
}

@end


@implementation NSDate (NSNumber)

+ (instancetype)dateWithoutMiniseconds:(NSNumber *)number{
    if (!number || ![number isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(number.longLongValue)];
    return date;
}

+ (instancetype)dateWithMiniseconds:(NSNumber *)number
{
    if (!number || ![number isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(number.longLongValue / 1000)];
    return date;
}
- (NSNumber *)toUnixTimeInMiniseconds
{
    return @((long long)([self timeIntervalSince1970] * 1000));
}
@end

@implementation NSDate (GetSpecificDate)

+ (NSDate *)ext_dateAtStartOfYear
{
    return [self ext_dateAtStartOfYearOfDate:[NSDate date]];
}

+ (NSDate *)ext_dateAtStartOfYearOfDate:(NSDate *)date
{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    [NSDate zeroOutTimeComponents:&components];
    [components setMonth:1];
    [components setDay:1];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)ext_dateAtStartOfYear {
    return [NSDate ext_dateAtStartOfYearOfDate:self];
}

- (void)ext_startDateInMonth:(NSDate *__autoreleasing *)start endDateInMonth:(NSDate *__autoreleasing *)endDate
{
    return [self ext_startDateInMonth:start endDateInMonth:endDate maximumEndDate:nil];
}

- (void)ext_startDateInMonth:(NSDate *__autoreleasing *)start endDateInMonth:(NSDate *__autoreleasing *)endDate maximumEndDate:(NSDate *)maximumDate
{
    NSCalendar* calendar = CURRENT_CALENDAR;
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    
    [comps setDay:1];
    NSDate *firstDay = [calendar dateFromComponents:comps];
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *lastDay = [calendar dateFromComponents:comps];
    if (maximumDate && ![lastDay isEarlierThanDate:maximumDate]) {
        lastDay = maximumDate;
    }
    if (start != NULL) {
        *start = firstDay;
    }
    if (endDate != NULL) {
        *endDate = lastDay;
    }
}

@end
