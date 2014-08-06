//
//  PieChartViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/28/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "PieChartViewController.h"

int WEEK_DAYS;
int WEEK_WORK;
int DAY_HOURS;

@implementation PieChartViewController
@synthesize user;
@synthesize apiClient;
@synthesize worketDays;
@synthesize pieChart;
@synthesize sliceColors;
@synthesize slices = _slices;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.slices = [NSMutableArray arrayWithCapacity:3];
 
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:14]];
    [self.pieChart setAnimationSpeed:2.0];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:0/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],nil];
}

- (void)viewDidUnload
{
    [self setPieChart:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    user = [[UserModel alloc] init];
    apiClient = [[APIClient alloc] init];
    [self updateSlices];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)showSlicePercentage:(UISwitch *)sender
{
    [self.pieChart setShowPercentage:sender.isOn];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

- (IBAction)updateSlices
{
    [_slices removeAllObjects];
    [self.pieChart reloadData];
    
    double delayInSeconds = 1.7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self requestChartData];
        [self.pieChart reloadData];
    });
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            [self showChartInfo:@"Hours should work" :index];
            break;
        case 1:
            [self showChartInfo:@"Hours worked" :index];
            break;
        case 2 :
            [self showChartInfo:@"Overtime" :index];
            break;
        default:
            break;
    }
}

- (void)showChartInfo:(NSString*)title :(NSUInteger)index{
    UIAlertView *chartInfo = [[UIAlertView alloc] initWithTitle:title
                                                        message:[self chartMessage:index]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [chartInfo show];
}

- (NSString*)chartMessage:(NSUInteger)index {
    NSString *message;
    
    switch (index) {
        case 0:{
            
            int worketDayLeft = (int)[self workingDays];
            int month = (worketDayLeft * 8) - [[self.slices objectAtIndex:1] intValue];
            int week = (WEEK_DAYS * 8) - WEEK_WORK;
            int dayHours   = month/worketDayLeft;
            int dayMin     = (month * 60 / worketDayLeft) % 60;

            message = [NSString stringWithFormat:@"\nUntil the end of the month: %dh\n\t\t\t\tweek: %dh\n\t\t\t\t\t day: %dh %dm",month,week,dayHours,dayMin];
        }
            break;
            
        case 1: {
            int worketDayInt = [worketDays intValue];
            int totalHours = [[self.slices objectAtIndex:index] intValue];
            int hours = (totalHours/worketDayInt)%24;
            int min   = (totalHours*60/worketDayInt)%60;
            
            message = [NSString stringWithFormat:@"Worket Days: %@\n\nThis month: %@ hours\nPer day: %dh %dm",worketDays,[self.slices objectAtIndex:index],hours,min];
        }
            break;
            
        case 2 :
            message = [NSString stringWithFormat:@"Total hours work: %@h",[self.slices objectAtIndex:index]];
            break;
            
        default:
            break;
    }

    return message;
}

- (void)requestChartData
{
    [apiClient reports:[user getToken] success:^(id response) {
        worketDays = [response valueForKeyPath:@"workedDays"];
        [self chartDataProcessing:[response valueForKeyPath:@"timeToWork"] :[response valueForKeyPath:@"monthly"]];
        WEEK_WORK = ([[response valueForKeyPath:@"weekly"] intValue] / (1000*60*60));
        DAY_HOURS = ([[response valueForKeyPath:@"daily"] intValue] / (1000*60*60));
    } failure:^(NSError *error) {
        [self showServerError:@"Server Error" :error];
    } sessionExpiry:^{
        [self sessionExpiry];
    }];
}

- (void)chartDataProcessing:(NSString*)baseHoursStr :(NSString*)workingHoursStr {

    int baseHours = ([baseHoursStr intValue] / (1000*60*60));
    int workingHours = ([workingHoursStr intValue] / (1000*60*60));
    
    [_slices removeAllObjects];
    for(int i = 0; i < 3; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:0];
        if ((i == 0) && ((baseHours - workingHours) > 0))  one = [NSNumber numberWithInt:(baseHours - workingHours)];
        if (i == 1)                                        one = [NSNumber numberWithInt:workingHours];
        if ((i == 2) && ((baseHours - workingHours) < 0))  one = [NSNumber numberWithInt:abs(baseHours - workingHours)];
        [_slices addObject:one];
    }
    [self.pieChart reloadData];
}

- (NSInteger)workingDays {
    
    BOOL weekEndDays = YES;
    NSInteger count = 0;
    NSInteger sunday = 1;
    NSInteger saturday = 7;
    
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    [oneDay setDay:1];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *dateComp = [calendar components:NSDayCalendarUnit fromDate:[NSDate date]];
    NSDate *toDate = [[NSDate alloc] init];
    NSDateComponents *daysToEnd = [[NSDateComponents alloc] init];
    [daysToEnd setDay:[[calendar components: NSWeekCalendarUnit fromDate:[NSDate date]] week] - [dateComp day]];
    toDate = [calendar dateByAddingComponents:daysToEnd toDate:currentDate options:0];
    
    while ( ([currentDate compare:toDate] == NSOrderedAscending)) {
        
        NSDateComponents *dateComponents = [calendar components:NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:currentDate];

        if (dateComponents.weekday != saturday && dateComponents.weekday != sunday) {
            count++;
            
        } else {
            if (weekEndDays) {
                WEEK_DAYS = (int)count;
                weekEndDays = NO;
            }
        }
        currentDate = [calendar dateByAddingComponents:oneDay
                                                toDate:currentDate
                                               options:0];
    }
    return count;
}

@end
