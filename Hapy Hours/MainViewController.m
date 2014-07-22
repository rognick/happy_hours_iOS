//
//  MainViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/12/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsTableViewController.h"
#import "Constants.h"
#import "APIClient.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIActivityIndicatorView+AFNetworking.h"



@interface MainViewController ()

@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSTimer *startTimerRequest;
@property (weak, nonatomic) IBOutlet UIProgressView *workTimeProgress;
@property (strong, nonatomic) APIClient *apiClient;

@end


@implementation MainViewController

@synthesize defaults;
@synthesize apiClient;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setToolbarHidden:NO animated:YES];
    
    apiClient = [[APIClient alloc] init];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    _loginSwitch.on = [defaults boolForKey:KEY_LOGIN];
    _timerSwitch.on = [defaults boolForKey:KEY_TIMER_ON];
    
}


#pragma -
- (IBAction)logInSwitch:(UISwitch *)sender {

    if (![defaults boolForKey:KEY_LOGIN]) {
        
        [apiClient userLogin:^(id result, NSError *error) {
            if (error) {_loginSwitch.on = [defaults boolForKey:KEY_LOGIN];}
            else{ _loginSwitch.on = [defaults boolForKey:KEY_LOGIN];}
        }];

    } else {
        [apiClient userLogOut:^(id result, NSError *error) {
            if (error) {_loginSwitch.on = [defaults boolForKey:KEY_LOGIN];}
            else {
                _loginSwitch.on = [defaults boolForKey:KEY_LOGIN];
                _timerSwitch.on = [defaults boolForKey:KEY_TIMER_ON];
                [self stopTimer];
            }
        }];
    }
//    _loginSwitch.on = [defaults boolForKey:KEY_LOGIN];

//    [self timerSwitch:_timerSwitch];
    
}

- (IBAction)timerSwitch:(UISwitch *)sender {
    
    if ([defaults boolForKey:KEY_LOGIN]) {
        if (sender.on) {
            [self startTimer];
        } else {[self stopTimer];}
        
    }else if (sender.on){
        _timerSwitch.on = false;
        [self showAlerts:@"Start Timer" :@"Required login"];
    }
}

-(void) startTimer {
    NSLog(@"Start");
    [apiClient start:^(id result, NSError *error) {
        if (!error) {NSLog(@"Timer start");[self nsTimer];}
    }];
}

-(void) stopTimer {
    NSLog(@"Stop");
    [apiClient stop:^(id result, NSError *error) {
        if (!error){
            NSLog(@"NStimer stop");
                    }
    }];
    [_startTimerRequest invalidate];
    _startTimerRequest = nil;
}

-(void) nsTimer {
    NSLog(@"NStimer Request");
    
    [self curentTimeRequest];
    if ([_startTimerRequest isValid]) {
        [_startTimerRequest invalidate];
        _startTimerRequest = nil;
    }
    _startTimerRequest = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                          target:self
                                                        selector:@selector(curentTimeRequest)
                                                        userInfo:nil
                                                         repeats:YES];
}

-(void) curentTimeRequest {

    [apiClient curentTime:@"TIME" complete:^(id result, NSError *error) {
        if (result) { [self timeConvertor:result];}
    }];
}

-(void) timeConvertor: (NSString*)millisecondsString {

    NSInteger milliseconds = [millisecondsString intValue];
    
    NSString *minutes = [self intToString: ((milliseconds / (1000*60)) % 60)];
    NSString *hours = [self intToString: ((milliseconds / (1000*60*60)) % 24)];
    
    float pr = ((0.002) * ((milliseconds / (1000*60))));
    if (pr > 1.0) {pr = 1.0;}
    
    _workTimeProgress.progress = pr;
    _timerLabel.text = [NSString stringWithFormat: @"%@h %@m",hours,minutes];
}

-(NSString*) intToString: (int) myInt {
    return [NSString stringWithFormat: @"%d",myInt];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([defaults boolForKey:KEY_TIMER_ON]) {
        [self nsTimer];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) showAlerts:(NSString *)title :(NSString *)alertMessage {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:alertMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
