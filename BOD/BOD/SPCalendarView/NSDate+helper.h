//
//  NSDate+helper.h
//  BOD
//
//  Created by Suraj on 19/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (helper)

- (NSUInteger)dayOfTheFirstDayOfCurrentMonth;
- (NSUInteger)currentDay;
- (NSString *)currentMonth;
- (NSString *)previousMonth;
- (NSString *)nextMonth;
- (NSUInteger)totalDaysInCurrentMonth;
- (NSUInteger)totalDaysInPreviousMonth;
- (BOOL) isItToday;

@end
