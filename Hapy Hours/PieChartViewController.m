//
//  PieChartViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/28/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "PieChartViewController.h"
#import "APIClient.h"

@implementation PieChartViewController
@synthesize pieChart;
@synthesize sliceColors;
@synthesize slices = _slices;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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
//    [self chartDataProcessing:@"192" :@"200"];
//    [self requestChartData];
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
    [self requestChartData];
    [self.pieChart reloadData];
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

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
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
        case 0:
            message = [NSString stringWithFormat:@"Estimated work hours\nIn a month: %@ hours\nWeek: 40 hours\nDay: 8 hours",[self.slices objectAtIndex:index]];
            break;
        case 1:
            message = [NSString stringWithFormat:@"Month: %@ hours\nWeek: 40 hours\nDay: 8 hours",[self.slices objectAtIndex:index]];
            break;
        case 2 :
            message = [NSString stringWithFormat:@"Estimated work hours\nIn a month: %@ hours\nWeek: 40 hours\nDay: 8 hours",[self.slices objectAtIndex:index]];
            break;
        default:
            break;
    }

    return message;
}

#pragma Wait from server service from base hours
- (void)requestChartData
{
    APIClient *apiClient = [[APIClient alloc]init];
    [apiClient reports:^(id result, NSError *error) {
        if (result) {
            NSLog(@"%@",result);
            [self chartDataProcessing:[result valueForKeyPath:@"timeToWork"] :[result valueForKeyPath:@"monthly"]];
        }
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
        if (i == 1)  one = [NSNumber numberWithInt:workingHours];
        if ((i == 2) && ((baseHours - workingHours) < 0))  one = [NSNumber numberWithInt:abs(baseHours - workingHours)];
        [_slices addObject:one];
    }
    [self.pieChart reloadData];
}

@end
