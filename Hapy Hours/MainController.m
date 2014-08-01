//
//  MainController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/23/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "MainController.h"
#import "Constants.h"

@interface MainController ()

@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSTimer *startTimerRequest;

@end


@implementation MainController
@synthesize apiClient;
@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
}

- (void)setUserUI {
    if ([_defaults boolForKey:KEY_TIMER_ON]) {
        _labelStartStop.backgroundColor = [UIColor greenColor];
        [_buttonStartStop setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        _labelStartStop.backgroundColor = [UIColor colorWithRed:245/255.0 green:131/255.0 blue:0/255.0 alpha:1];
        [_buttonStartStop setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    user = [[UserModel alloc] init];
    apiClient = [[APIClient alloc] init];
    [self setUserUI];
    [self setTimerLoop];
}

- (IBAction)startStop:(UIButton *)sender {
    if (user.isValidToken) {
        
        if ([_buttonStartStop.titleLabel.text isEqualToString:@"Start"]) {
            
            [apiClient startTimer:[user getToken] success:^(id response) {
                [_defaults setBool:true forKey:KEY_TIMER_ON];
                [_defaults synchronize];
                [self setUserUI];
                [self startTimerLoop];
            } failure:^(NSError *error) {
                if (error) {
                    [self showServerError:@"Error to Start Timer" :error];
                } else {
                    [_defaults setBool:true forKey:KEY_TIMER_ON];
                }
            } sessionExpiry:^{
                [self sessionExpiry];
            }];
            
        } else {
            [apiClient stopTimer:[user getToken] success:^(id response) {
                [_defaults setBool:false forKey:KEY_TIMER_ON];
                [_defaults synchronize];
                [self setUserUI];
                [self stopTimerLoop];
            } failure:^(NSError *error) {
                if (error) {
                    [self showServerError:@"Error to Stop Timer" :error];
                } else {
                    [_defaults setBool:false forKey:KEY_TIMER_ON];
                }
            } sessionExpiry:^{
                [self sessionExpiry];
            }];
        }
        
    } else {
        [self showLogin];
    }
}

- (void)setTimerLoop {
    user = [[UserModel alloc] init];
    _defaults = [NSUserDefaults standardUserDefaults];
    if ([_defaults boolForKey:KEY_TIMER_ON] && [user isValidToken]) {
        [self startTimerLoop];
    } else {
        [self stopTimerLoop];
    }
}

- (void)startTimerLoop {
    [self stopTimerLoop];
    [self updateTimeReports];
#warning set timer loop
    _startTimerRequest = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateTimeReports)
                                                        userInfo:nil
                                                        repeats:YES];
}

- (void)stopTimerLoop {
    if ([_startTimerRequest isValid]) {
        [_startTimerRequest invalidate];
        _startTimerRequest = nil;
    }
}

- (void)updateTimeReports {
    
    [apiClient reports:[user getToken] success:^(id response) {
        _dayTotalLabel.text   = [self timeConvertor:[response valueForKeyPath:@"daily"]];
        _weekTotalLabel.text  = [self timeConvertor:[response valueForKeyPath:@"weekly"]];
        _monthTotalLabel.text = [self timeConvertor:[response valueForKeyPath:@"monthly"]];
        _progressBar.progress = [self progressBarConvert:[response valueForKeyPath:@"daily"]];
    } failure:^(NSError *error) {
        [self stopTimerLoop];
        [self showServerError:@"Server Error" :error];
    } sessionExpiry:^{
        [self stopTimerLoop];
        [self sessionExpiry];
    }];
}

- (NSString*)timeConvertor: (NSString*)millisecondsString {
    NSInteger milliseconds = [millisecondsString intValue];
    NSString *minutes = [self intToString: ((milliseconds / (1000*60)) % 60)];
    NSString *hours = [self intToString: ((milliseconds / (1000*60*60)) % 24)];
    
    return [NSString stringWithFormat: @"%@h %@m",hours,minutes];
}

- (float)progressBarConvert: (NSString*)millisecondsString {
    NSInteger milliseconds = [millisecondsString intValue];
    float pr = ((0.002) * ((milliseconds / (1000*60))));
    if (pr > 1.0) {pr = 1.0;}

    return pr;
}

- (NSString*)intToString: (int)myInt {
    return [NSString stringWithFormat: @"%d",myInt];
}

@end
