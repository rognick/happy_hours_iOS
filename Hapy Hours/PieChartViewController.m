//
//  PieChartViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/28/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "PieChartViewController.h"

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
    
    for(int i = 0; i < 3; i ++)
    {
        //        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
        NSNumber *one; //= [NSNumber numberWithInt:20];
        if (i == 0)  one = [NSNumber numberWithInt:160];
        if (i == 1)  one = [NSNumber numberWithInt:20];
        if (i == 2)  one = [NSNumber numberWithInt:20];
        [_slices addObject:one];
    }
    
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:14]];
    [self.pieChart setAnimationSpeed:2.0];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:0/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:248/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
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
//    self.label.text = [NSString stringWithFormat:@"%@",[self.slices objectAtIndex:index]];
    [self showChartInfo:[NSString stringWithFormat:@"%@",[self.slices objectAtIndex:index]] :@"Bla bal"];
}

- (void)showChartInfo:(NSString*)title :(NSString*)message {
    UIAlertView *chartInfo = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [chartInfo show];
}

@end
