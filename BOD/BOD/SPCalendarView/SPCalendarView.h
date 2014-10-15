//
//  SPCalendarView.h
//  BOD
//
//  Created by Suraj on 17/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPCalendarView;

@protocol CalendarDelegate <NSObject>

- (void) calendarView:(SPCalendarView *)calendarView didMoveToIndexPath:(NSIndexPath *)indexpath;								// set this to do whatever action you want to do when you move to a grid of the calendar
- (void) calendarView:(SPCalendarView *)calendarView didSelectCalendarViewAtIndexPath:(NSIndexPath *)indexpath; // once a grid is highlighted, subsequent tap on the grid will call this method
@end

@protocol CalendarDataSource <NSObject>

@optional
- (NSInteger)numberOfRows;															// do not set this if you want is a month calendar
- (NSInteger)numberOfColumns;														// do not set this if you want is a month calendar
- (NSDate *)setDate;																		// use this to set the calendar for the month you wish
- (CGSize)defaultBoxSize;																// default box size of 40X60 will be used if not set
-	(UIView *)viewForCellAtRow:(NSInteger)row
									 AndColumn:(NSInteger)column;					// no need to set if you want is a month calendar
-	(UIView *)selectedViewForCellAtRow:(NSInteger)row
													 AndColumn:(NSInteger)column;	// no need to set if you want is a month calendar

@end

typedef enum {
	BoxTypeCalendar = 0,
	BoxTypeOther    = 1
}BoxType;


@interface SPCalendarView : UIView

@property (nonatomic, strong) id<CalendarDelegate> delegate;
@property (nonatomic, strong) id<CalendarDataSource> dataSource;

@property (nonatomic) BoxType boxType;

- (void)showStartUpAnimation;
- (void)dismissHighlightViewOnCompletion:(void(^)(void))completion;
- (void)showHideAllSubviewsHide:(BOOL)hide;
- (void)reloadData;

@end
