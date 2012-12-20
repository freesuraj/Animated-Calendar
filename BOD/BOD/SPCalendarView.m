//
//  SPCalendarView.m
//  BOD
//
//  Created by Suraj on 17/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import "SPCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+helper.h"

#define defaultTodayColor					[UIColor colorWithRed:55.0/255.0 green:105.0/255.0 blue:105.0/255.0 alpha:0.6]
#define defaultHighlightColorRt		[UIColor colorWithRed:236.0/255.0 green:46.0/255.0 blue:43.0/255.0 alpha:1.0]
#define defaultHighlightColorLt		[UIColor colorWithRed:186.0/255.0 green:34.0/255.0 blue:39.0/255.0 alpha:1.0]

#define defaultDayFont						[UIFont fontWithName:@"Noteworthy-Bold" size:15]
#define selectedDayFont						[UIFont fontWithName:@"Papyrus" size:15]
#define defaultMonthFont					[UIFont fontWithName:@"Arial-BoldMT" size:12]

#define defaultFrame							CGRectMake(0, 0, 40, 60)
#define defaultRows								6
#define defaultColumns						7
#define defaultCornerRadius				6.0

#define kTagMultiplier						11111
#define kSeed											231

@interface SPCalendarView()
@property (nonatomic) CGRect boxFrame;
@property (nonatomic) NSInteger rows, columns;
@property (nonatomic, strong) UIView *highlightedView;
@property (nonatomic, strong) NSIndexPath *highlightedIndexPath;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger counts;
@property (nonatomic, strong) NSDate *currentDate;

- (void)setUpCalendar;

@end

@implementation SPCalendarView
@synthesize boxFrame,rows,columns,delegate,dataSource,highlightedView,highlightedIndexPath,timer,counts,currentDate;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor greenColor];
	}
	return self;
}

- (void)reloadData
{
	[self setUpCalendar];
	[self addGestureRecognizer];
	[self setNeedsDisplay];
}

- (UIView *)defaultBoxAtRow:(NSInteger)row AndColumn:(NSInteger)column
{
	UIView *box;
	box.tag = (row+kSeed)*kTagMultiplier+(column+kSeed);
	if([self.dataSource respondsToSelector:@selector(viewForCellAtRow:AndColumn:)]){
		box = [self.dataSource viewForCellAtRow:row AndColumn:column];
		return box;
	}
	box = [[UIView alloc]initWithFrame:self.boxFrame];
	box.backgroundColor = [UIColor clearColor];
	UIView *textLabelView = [self normalViewForCellAtRow:row AndColumn:column];
	[box addSubview:textLabelView];
	box.tag = (row+kSeed)*kTagMultiplier+(column+kSeed);
	box.layer.borderWidth = 0.5;
	box.layer.borderColor = [UIColor blackColor].CGColor;
	box.layer.cornerRadius = defaultCornerRadius;
	
	return box;
}

- (UIView *)defaultSelectedBoxAtRow:(NSInteger)row AndColumn:(NSInteger)column
{
	UIView *box;
	if([self.dataSource respondsToSelector:@selector(selectedViewForCellAtRow:AndColumn:)]){
		box = [self.dataSource selectedViewForCellAtRow:row AndColumn:column];
		return box;
	}
	box = [[UIView alloc]initWithFrame:self.boxFrame];
	box.backgroundColor = [UIColor clearColor];
	
	UIView *textLabelView = [self highlightedViewForCellAtRow:row AndColumn:column];
	[box addSubview:textLabelView];
	box.layer.cornerRadius = defaultCornerRadius;
	return box;
}

- (NSString *)textForCellAtRow:(NSInteger)row AndColumn:(NSInteger)column
{
	// get current date:
	NSInteger indexOfFirstDate  = [self.currentDate dayOfTheFirstDayOfCurrentMonth]-1;
	NSInteger prevMonthsTotal   = [self.currentDate totalDaysInPreviousMonth];
	NSInteger currMonthsTotal   = [self.currentDate totalDaysInCurrentMonth];
	NSInteger dayForTheCell = row*self.columns+column+1-indexOfFirstDate;
	
	if(row*self.columns+column < indexOfFirstDate){
		dayForTheCell = prevMonthsTotal - (indexOfFirstDate - column - 1) ;
	}
	else if(dayForTheCell > currMonthsTotal){
		dayForTheCell = dayForTheCell - currMonthsTotal ;
	}
	else {
	}
	
	return [NSString stringWithFormat:@"%d",dayForTheCell];
}

- (UIView *)normalViewForCellAtRow:(NSInteger)row AndColumn:(NSInteger)column
{
	// get current date:
	NSInteger indexOfFirstDate  = [self.currentDate dayOfTheFirstDayOfCurrentMonth]-1;
	NSInteger prevMonthsTotal   = [self.currentDate totalDaysInPreviousMonth];
	NSInteger currMonthsTotal   = [self.currentDate totalDaysInCurrentMonth];
	NSInteger dayForTheCell = row*self.columns+column+1-indexOfFirstDate;
	NSString *monthName;
	
	// calculate date for each cell, to find the cell for Today
	NSCalendar *gregorian = [[NSCalendar alloc]
													 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents =
	[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.currentDate];
	
	if(row*self.columns+column < indexOfFirstDate){
		dayForTheCell = prevMonthsTotal - (indexOfFirstDate - column - 1) ;
		monthName = [self.currentDate previousMonth];
		[dateComponents setMonth:[dateComponents month] - 1];
	}
	else if(dayForTheCell > currMonthsTotal){
		dayForTheCell = dayForTheCell - currMonthsTotal ;
		monthName = [self.currentDate nextMonth];
		[dateComponents setMonth:[dateComponents month] + 1];
	}
	else {
		monthName = [self.currentDate currentMonth];
	}
	
	[dateComponents setDay:dayForTheCell];
	NSDate *dateForThisCell = [gregorian dateFromComponents:dateComponents];
	
	
	
	// View
	UIView *viewToReturn = [[UIView alloc]initWithFrame:self.boxFrame];
	UIView *upperView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.boxFrame.size.width/2, self.boxFrame.size.height)];
	UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(-upperView.frame.size.width, upperView.frame.size.height*0.35, upperView.frame.size.height, upperView.frame.size.width)];
	textLabel.text = [monthName uppercaseString];
	textLabel.textColor = [UIColor whiteColor];
	textLabel.font = defaultMonthFont;
	textLabel.textAlignment = UITextAlignmentCenter;
	[textLabel setClipsToBounds:YES];
	textLabel.backgroundColor = [UIColor clearColor];
	[upperView setBackgroundColor:[UIColor clearColor]];
	textLabel.transform = CGAffineTransformMakeRotation(3*M_PI/2);
	[upperView addSubview:textLabel];
	
	// day
	UIView *lowerView = [[UIView alloc]initWithFrame:CGRectMake(self.boxFrame.size.width/4, 0, self.boxFrame.size.width * 3/4, self.boxFrame.size.height)];
	UILabel *textLabelDay = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, lowerView.frame.size.width, lowerView.frame.size.height)];
	textLabelDay.text = [NSString stringWithFormat:@"%d",dayForTheCell];
	textLabelDay.textColor = [UIColor redColor];
	textLabelDay.font = defaultDayFont;
	textLabelDay.textAlignment = UITextAlignmentRight;
	[textLabelDay setClipsToBounds:YES];
	
	textLabelDay.backgroundColor = [UIColor clearColor];
	[lowerView setBackgroundColor:[UIColor clearColor]];
	[lowerView addSubview:textLabelDay];
	
	if(dayForTheCell == 1)
		[viewToReturn addSubview:upperView];
	
	if([dateForThisCell isItToday])
	{
		[viewToReturn setBackgroundColor:defaultTodayColor];
		
		[viewToReturn addSubview:upperView];
		viewToReturn.layer.masksToBounds = YES;
	}
	
	[viewToReturn addSubview:lowerView];
	
	return viewToReturn;

}

- (UIView *)highlightedViewForCellAtRow:(NSInteger)row AndColumn:(NSInteger)column
{
	
	// get current date:
	NSInteger indexOfFirstDate  = [self.currentDate dayOfTheFirstDayOfCurrentMonth]-1;
	NSInteger prevMonthsTotal   = [self.currentDate totalDaysInPreviousMonth];
	NSInteger currMonthsTotal   = [self.currentDate totalDaysInCurrentMonth];
	NSInteger dayForTheCell = row*self.columns+column+1-indexOfFirstDate;
	NSString *monthName;
	if(row*self.columns+column < indexOfFirstDate){
		dayForTheCell = prevMonthsTotal - (indexOfFirstDate - column - 1) ;
		monthName = [self.currentDate previousMonth];
	}
	else if(dayForTheCell > currMonthsTotal){
		dayForTheCell = dayForTheCell - currMonthsTotal ;
		monthName = [self.currentDate nextMonth];
	}
	else {
		monthName = [self.currentDate currentMonth];
	}

	// View
	UIView *viewToReturn = [[UIView alloc]initWithFrame:self.boxFrame];
	viewToReturn.layer.cornerRadius = defaultCornerRadius;
	viewToReturn.layer.masksToBounds = YES;
	UIView *upperView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.boxFrame.size.width/2, self.boxFrame.size.height)];
	UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(-upperView.frame.size.width, upperView.frame.size.height*0.35, upperView.frame.size.height, upperView.frame.size.width)];
	textLabel.text = [monthName uppercaseString];
	textLabel.textColor = [UIColor blackColor];
	textLabel.font = defaultMonthFont;
	textLabel.textAlignment = UITextAlignmentCenter;
	[textLabel setClipsToBounds:YES];
	textLabel.backgroundColor = [UIColor clearColor];
	[upperView setBackgroundColor:defaultHighlightColorLt];
	textLabel.transform = CGAffineTransformMakeRotation(3*M_PI/2);
	[upperView addSubview:textLabel];
	// day
	UIView *lowerView = [[UIView alloc]initWithFrame:CGRectMake(self.boxFrame.size.width/2, 0, self.boxFrame.size.width/2, self.boxFrame.size.height)];
	UILabel *textLabelDay = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, lowerView.frame.size.width, lowerView.frame.size.height)];
	textLabelDay.text = [NSString stringWithFormat:@"%d",dayForTheCell];
	textLabelDay.textColor = [UIColor whiteColor];
	textLabelDay.font = selectedDayFont;
	textLabelDay.textAlignment = UITextAlignmentCenter;
	[textLabelDay setClipsToBounds:YES];
	textLabelDay.backgroundColor = [UIColor clearColor];
	[lowerView setBackgroundColor:defaultHighlightColorRt];
	[lowerView addSubview:textLabelDay];
	
	[viewToReturn addSubview:upperView];
	[viewToReturn addSubview:lowerView];
	return viewToReturn;
}

- (void)setUpCalendar
{
	[self readDataSource];
	self.frame = CGRectMake(0, 0, self.columns*self.boxFrame.size.width, self.rows*self.boxFrame.size.height);
	for(int i=0;i<self.columns;i++)
	{
		for(int j=0;j<self.rows;j++)
		{
			UIView *box = [self defaultBoxAtRow:j AndColumn:i];
			CGFloat w = box.frame.size.width;
			CGFloat h = box.frame.size.height;
			box.center = CGPointMake(i*w+w/2, j*h+h/2);
			[self addSubview:box];
		}
	}
}

- (void)readDataSource
{
	// read box size
	if([self.dataSource respondsToSelector:@selector(defaultBoxSize)]){
		CGSize defSize = [self.dataSource defaultBoxSize];
		self.boxFrame = CGRectMake(0, 0, defSize.width, defSize.height);
	}
	else self.boxFrame = defaultFrame;
	// read rows
	if([self.dataSource respondsToSelector:@selector(numberOfRows)]) self.rows = [self.dataSource numberOfRows];
	else self.rows = defaultRows;
	// read columns
	if([self.dataSource respondsToSelector:@selector(numberOfColumns)]) self.columns = [self.dataSource numberOfColumns];
	else self.columns = defaultColumns;
	// read date
	if([self.dataSource respondsToSelector:@selector(setDate)]) self.currentDate = [self.dataSource setDate];
	else self.currentDate = [NSDate date];
}

- (void)showStartUpAnimation
{
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startupHighlightAnIndexPath) userInfo:nil repeats:YES];
}

- (void)startupHighlightAnIndexPath
{
	self.counts ++;
	if(self.counts >= 6){
		self.timer = nil;
		return;
	}
	int row = 3;
	int column = self.counts;
	[self.highlightedView removeFromSuperview];
	self.highlightedView = [self defaultSelectedBoxAtRow:row AndColumn:column];
	self.highlightedView.frame = [self viewWithTag:(row+kSeed)*kTagMultiplier+(column+kSeed)].frame;
	[self addSubview:self.highlightedView];
	self.highlightedView.userInteractionEnabled = YES;
	
	if([self.delegate respondsToSelector:@selector(calendarView:didMoveToIndexPath:)])
		[self.delegate calendarView:self didMoveToIndexPath:[NSIndexPath indexPathForRow:row inSection:column]];
}

- (NSIndexPath *)indexPathForPoint:(CGPoint)point
{
	for(UIView *view in self.subviews)
	{
		if(CGRectContainsPoint(view.frame, point))
		{
			int row = view.tag/kTagMultiplier - kSeed;
			int column = view.tag % kTagMultiplier - kSeed;
			[self.highlightedView removeFromSuperview];
			self.highlightedView = [self defaultSelectedBoxAtRow:row AndColumn:column];
			self.highlightedView.frame = view.frame;
			[self addSubview:self.highlightedView];
			return [NSIndexPath indexPathForRow:row inSection:column];
		}
	}
	return nil;
}

//============================================================================
#pragma mark - Animation Functions
//============================================================================

- (void)showGlowTraceAtIndexPath:(NSIndexPath *)indexPath
{
	CGRect glowFrame = [self viewWithTag:(indexPath.row+kSeed)*kTagMultiplier+(indexPath.section+kSeed)].frame;
	UIView *glowView = [[UIView alloc]initWithFrame:glowFrame];
	[glowView setBackgroundColor:[UIColor whiteColor]];
	[glowView setAlpha:0.7];
	[self addSubview:glowView];
	[UIView animateWithDuration:0.4 animations:^{
		[glowView setAlpha:0.0];
	} completion:^(BOOL finished) {
		[glowView removeFromSuperview];
	}];
}

- (void)showFadingWhiteBorderOnSelectedView
{
	UIView *borderView = [[UIView alloc]initWithFrame:self.highlightedView.frame];
	[self addSubview:borderView];
	borderView.backgroundColor = [UIColor clearColor];
	borderView.layer.borderWidth = 1.2;
	borderView.layer.cornerRadius = defaultCornerRadius;
	borderView.layer.borderColor = [UIColor whiteColor].CGColor;
	[UIView animateWithDuration:0.6 animations:^{
		borderView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[borderView removeFromSuperview];
	}];
}

- (void)dismissHighlightViewOnCompletion:(void(^)(void))completion
{
	CGFloat newX = self.frame.size.width - boxFrame.size.width/2;
	CGFloat newY = - self.frame.size.width;
	
	NSTimeInterval firstAnimationDuration		= (newX == self.highlightedView.center.y) ? 0.0 : 0.6;
	NSTimeInterval secondAnimationDuration	= 0.6;

	[UIView animateWithDuration:firstAnimationDuration animations:^{
		self.highlightedView.center = CGPointMake(newX, self.highlightedView.center.y);
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:secondAnimationDuration animations:^{
			self.highlightedView.center = CGPointMake(self.highlightedView.center.x, newY);
		} completion:^(BOOL finished) {
			self.highlightedIndexPath = nil;
			completion();
		}];
	}];

}

- (void)showHideAllSubviewsHide:(BOOL)hide
{
	CGFloat alpha = hide ? 0.0 : 1.0;
		[UIView animateWithDuration:0.7 animations:^{
			for(UIView *aView in self.subviews)
				[aView setAlpha:alpha];
			self.userInteractionEnabled = !hide;
		}];		
}



//============================================================================
#pragma mark - Gesture Handler
//============================================================================

- (void)addGestureRecognizer
{
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gestured:)];
	[pan setMaximumNumberOfTouches:2];
	[pan setMinimumNumberOfTouches:1];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestured:)];
	[self addGestureRecognizer:pan];
	[self addGestureRecognizer:tap];
}

- (void)gestured:(UIGestureRecognizer *)gesture
{
	CGPoint point = [gesture locationInView:self];
	NSIndexPath *oldIndexPath = self.highlightedIndexPath;
	self.highlightedIndexPath = [self indexPathForPoint:point];
	
	
	if(gesture.state == UIGestureRecognizerStateEnded)
		[self showFadingWhiteBorderOnSelectedView];
	
	if(oldIndexPath == nil || ([oldIndexPath isEqual:self.highlightedIndexPath] == NO &&
		 self.highlightedIndexPath != nil))
	{
		if([self.delegate respondsToSelector:@selector(calendarView:didMoveToIndexPath:)])
			[self.delegate calendarView:self didMoveToIndexPath:self.highlightedIndexPath];
				
		if([gesture isKindOfClass:[UIPanGestureRecognizer class]])
			[self showGlowTraceAtIndexPath:oldIndexPath];
		
	}
	else if([oldIndexPath isEqual:self.highlightedIndexPath] == YES &&
					[gesture isKindOfClass:[UITapGestureRecognizer class]])
	{

		if([self.delegate respondsToSelector:@selector(calendarView:didSelectCalendarViewAtIndexPath:)])
			[self.delegate calendarView:self didSelectCalendarViewAtIndexPath:self.highlightedIndexPath];

	}
	
}


@end
