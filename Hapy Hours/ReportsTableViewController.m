//
//  ReportsTableViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/22/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "ReportsTableViewController.h"
#import "APIClient.h"

@interface ReportsTableViewController ()

@end


@implementation ReportsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    APIClient *apiClient = [[APIClient alloc] init];
    [apiClient reports:^(id result, NSError *error) {
        if (result) {
            _dayLabel.text   = [self timeConvertor:[result valueForKeyPath:@"daily"]];
            _weekLabel.text  = [self timeConvertor:[result valueForKeyPath:@"weekly"]];
            _monthLabel.text = [self timeConvertor:[result valueForKeyPath:@"monthly"]];
        }
    }];
}

-(NSString*) timeConvertor: (NSString*)millisecondsString {
    
    NSInteger milliseconds = [millisecondsString intValue];
    
    NSString *minutes = [self intToString: ((milliseconds / (1000*60)) % 60)];
    NSString *hours = [self intToString: ((milliseconds / (1000*60*60)) % 24)];
    
    return [NSString stringWithFormat: @"%@ : %@",hours,minutes];
}

-(NSString*) intToString: (int) myInt {
    return [NSString stringWithFormat: @"%d",myInt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
