//
//  NSDate+helper.m
//  BOD
//
//  Created by Suraj on 19/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import "NSDate+helper.h"

@implementation NSDate (helper)

- (NSUInteger)dayOfTheFirstDayOfCurrentMonth	// weekday of the current month, 1 = Sunday, 7 = Saturday
{
	NSDate *today = self;
	NSCalendar *gregorian = [[NSCalendar alloc]
													 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
																											fromDate:today];
	
	[components setDay:1];
	NSDate *dateFirstDay = [gregorian dateFromComponents:components];
	int weekday = [[gregorian components:NSWeekdayCalendarUnit fromDate:dateFirstDay] weekday];
	return weekday;
}

- (NSUInteger)currentDay
{
	NSDate *today = self;
	NSCalendar *gregorian = [[NSCalendar alloc]
													 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents =
	[gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
	NSInteger day = [weekdayComponents day];
	return day;
}

- (NSString *)currentMonth
{
	NSDateFormatter *df = [[NSDateFormatter alloc]init];
	[df setDateFormat:@"MMM"];
	return [df stringFromDate:self];
}

- (NSString *)nextMonth
{
	NSDate *today = self;
	NSCalendar *gregorian = [[NSCalendar alloc]
													 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *monthComponents =
	[gregorian components:(NSMonthCalendarUnit) fromDate:today];
	[monthComponents setMonth:[monthComponents month] + 1];
	NSDate *nextMonth = [gregorian dateFromComponents:monthComponents];
	NSDateFormatter *df = [[NSDateFormatter alloc]init];
	[df setDateFormat:@"MMM"];
	return [df stringFromDate:nextMonth];
}

- (NSString *)previousMonth
{
	NSDate *today = self;
	NSCalendar *gregorian = [[NSCalendar alloc]
													 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *monthComponents =
	[gregorian components:(NSMonthCalendarUnit) fromDate:today];
	[monthComponents setMonth:[monthComponents month] - 1];
	NSDate *nextMonth = [gregorian dateFromComponents:monthComponents];
	NSDateFormatter *df = [[NSDateFormatter alloc]init];
	[df setDateFormat:@"MMM"];
	return [df stringFromDate:nextMonth];
}

- (NSUInteger)totalDaysInCurrentMonth
{
	NSDate *today = self;
	NSCalendar *gregorian = [[NSCalendar alloc]
													 initWithCalendarIdentifier:NSGregorianCalendar];
	NSRange days = [gregorian rangeOfUnit:NSDayCalendarUnit
												 inUnit:NSMonthCalendarUnit
												forDate:today];
	return days.length;
}

- (NSUInteger)totalDaysInPreviousMonth
{
	NSDate *today = self;
	NSCalendar *gregorian = [[NSCalendar alloc]
													 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *monthComponents =
	[gregorian components:(NSMonthCalendarUnit) fromDate:today];
	[monthComponents setMonth:[monthComponents month] - 1];
	NSRange days = [gregorian rangeOfUnit:NSDayCalendarUnit
																 inUnit:NSMonthCalendarUnit
																forDate:[gregorian dateFromComponents:monthComponents]];
	return days.length;
}

-(NSInteger) secondsFromTheDate:(NSDate *)dateToCompare {
	
	NSCalendar *currentCalendar =[[NSCalendar alloc]
																initWithCalendarIdentifier:NSGregorianCalendar];

	unsigned int unitFlags = NSSecondCalendarUnit;
	NSDateComponents *components = [currentCalendar components: unitFlags fromDate: self toDate: dateToCompare options: 1];
	return [components second];
}

- (BOOL) isItToday
{
	NSInteger secs = [self secondsFromTheDate:[NSDate date]];
	if( secs > 0 && secs < (24*60*60)) return YES;
	else return NO;
}

@end
