//
//  SPViewController.m
//  BOD
//
//  Created by Suraj on 17/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import "SPViewController.h"

#define defaultFrame		CGRectMake(0, 0, 30, 30)


@interface SPViewController ()<CalendarDelegate,CalendarDataSource>

@property (strong, nonatomic) SPCalendarView *aCalendar;
@property (strong, nonatomic) IBOutlet UIButton *showHideCalendarButton;

- (IBAction)showHideCalendar:(UIButton *)sender;

@end

@implementation SPViewController
@synthesize aCalendar, showHideCalendarButton;

//============================================================================
#pragma mark - View Lifecycle
//============================================================================

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-568h"]];
	[self.showHideCalendarButton setHidden:YES];
	self.aCalendar = [[SPCalendarView alloc]initWithFrame:defaultFrame];
	self.aCalendar.delegate = self;
	self.aCalendar.dataSource = self;
	[self.view addSubview:self.aCalendar];
	[self.aCalendar reloadData];
	self.aCalendar.center = self.view.center;
	[self.aCalendar showStartUpAnimation];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
	[self setShowHideCalendarButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


//============================================================================
#pragma mark - CalendarDelegate/ DataSource
//============================================================================

// Either leave these two empty(use default) or give views
/*
- (NSInteger)numberOfRows{
	return 5;
}
- (NSInteger)numberOfColumns{
	return 7;
}
- (CGSize)defaultBoxSize;{
	return CGSizeMake(40, 60);
}

-	(UIView *)viewForCellAtRow:(NSInteger)row AndColumn:(NSInteger)column;{
	
}
-	(UIView *)selectedViewForCellAtRow:(NSInteger)row AndColumn:(NSInteger)column;{
	
}
 

- (NSDate *)setDate{
	// next month
	NSCalendar *gregorian = [[NSCalendar alloc]
													 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *monthComponents =
	[gregorian components:(NSMonthCalendarUnit) fromDate:[NSDate date]];
	[monthComponents setMonth:[monthComponents month] + 1];
	NSDate *nextMonth = [gregorian dateFromComponents:monthComponents];
	return nextMonth;
}
 
 */

- (void)calendarView:(SPCalendarView *)calendarView didMoveToIndexPath:(NSIndexPath *)indexpath
{
	// randomly pick an image to be calendarView's background
	int randomNumber = arc4random()%10;
	NSString *backgroundImgName = [NSString stringWithFormat:@"bigsample%d.jpg",randomNumber];
	calendarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImgName]];
}

- (void)calendarView:(SPCalendarView *)calendarView didSelectCalendarViewAtIndexPath:(NSIndexPath *)indexpath
{
	[calendarView dismissHighlightViewOnCompletion:^{
		[calendarView showHideAllSubviewsHide:YES];
		[self.showHideCalendarButton setHidden:NO];
	}];
}


- (IBAction)showHideCalendar:(UIButton *)sender {
	[self.aCalendar showHideAllSubviewsHide:NO];
	[sender setHidden:YES];
}
@end
