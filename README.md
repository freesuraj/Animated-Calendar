Animated-Calendar
=================

A clone of animated calendar similar to the one used in Band of the day app (https://itunes.apple.com/us/app/band-of-the-day/id459664402?mt=8)

Features
---------
* incredibly easy to use and customize
* drag around calendar, set action for whatever you want for when a particular grid is selected.
* Beautiful animations around while dragging, tapping and selecting a grid !

How to use
-----------
**Files**

Copy 4 files in the group (SPCalendar) into your project and you're ready to roll:

`SPCalendarView.h`

`SPCalendarView.m`

`NSDate+helper.h`

`NSDate+helper.m`

**Frameworks**

`QuartzCore.framework`

`CoreGraphics.framework`

**Usage**

1. init


	
		SPCalendarView *calendar = [[SPCalendarView alloc]initWithFrame:defaultFrame]
		
		
2. Setting datasource and action handlers using two protocols, `CalendarDelegate` and `CalendarDataSource`

	*CalendarDelegate*
	
		@protocol CalendarDelegate <NSObject>

		- (void) calendarView:(SPCalendarView *)calendarView didMoveToIndexPath:(NSIndexPath *)indexpath;								// set this to do whatever action you want to do when you move to a grid of the calendar
		- (void) calendarView:(SPCalendarView *)calendarView didSelectCalendarViewAtIndexPath:(NSIndexPath *)indexpath; // once a grid is highlighted, subsequent tap on the grid will call this method
		@end

	*CalendarDataSource*
	
		@protocol CalendarDataSource <NSObject>

			@optional
			- (NSInteger)numberOfRows;															// do not set this if you want is a month calendar
			- (NSInteger)numberOfColumns;														// do not set this if you want is a month calendar
			- (NSDate *)setDate;																		// use this to set the calendar for the month you wish
			- (CGSize)defaultBoxSize;																// default box size of 40X60 will be used if not set
			-	(UIView *)viewForCellAtRow:(NSInteger)row
												 AndColumn:(NSInteger)column;					// no need to set if you want is a month calendar
			-	(UIView *)selectedViewForCellAtRow:(NSInteger)row AndColumn:(NSInteger)column;	// no need to set if you want is a month calendar
																 @end






