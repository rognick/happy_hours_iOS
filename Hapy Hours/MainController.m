//
//  MainController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/23/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "MainController.h"
#import "UserModel.h"
#import "APIClient.h"
#import "Constants.h"

@interface MainController ()

@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) APIClient *apiClient;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSTimer *startTimerRequest;

@end


@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _user = [[UserModel alloc]init];
    _defaults = [NSUserDefaults standardUserDefaults];
    
    
}

- (void)setUserUI:(BOOL)enable {
    if (enable) {
        _labelStartStop.backgroundColor = [UIColor greenColor];
        [_buttonStartStop setTitle:@"Stop" forState:UIControlStateNormal];
//        [_buttonStartStop setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    } else {
        _labelStartStop.backgroundColor = [UIColor colorWithRed:245/255.0 green:131/255.0 blue:0/255.0 alpha:1];
        [_buttonStartStop setTitle:@"Start" forState:UIControlStateNormal];
//        [_buttonStartStop setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    _apiClient = [[APIClient alloc]init];
    [self setUserUI:[_defaults boolForKey:KEY_TIMER_ON]];
    
    if ([_defaults boolForKey:KEY_TIMER_ON] && _user.isValidToken) {
        [self startTimerLoop];
    } else {
        [self stopTimerLoop];
    }
}

- (IBAction)startStop:(UIButton *)sender {
    if (_user.isValidToken) {
        
        if ([_buttonStartStop.titleLabel.text isEqualToString:@"Start"]) {
            [_apiClient start:^(id result, NSError *error) {
                if (!error) {
                    [self setUserUI:true];
                    [_defaults setBool:true forKey:KEY_TIMER_ON];
                    [_defaults synchronize];
                    [self startTimerLoop];
                }
            }];
        } else {
            [_apiClient stop:^(id result, NSError *error) {
                if (!error){
                    [self setUserUI:false];
                    [_defaults setBool:false forKey:KEY_TIMER_ON];
                    [_defaults synchronize];
                    [self stopTimerLoop];
                }
            }];
        }
        
    } else {
        [self showLogin];
    }
}

- (void)showLogin {
    UIAlertView *logIn = [[UIAlertView alloc] initWithTitle:@"Login"
                                                    message:@"Enter Username & Password"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Login",nil];

    logIn.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [logIn show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login process\nPlease Wait..."
                                       message:nil
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame= CGRectMake(50, 10, 37, 37);
    activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [activityIndicator startAnimating];
    [alert setValue:activityIndicator forKey:@"accessoryView"];
    
    if([title isEqualToString:@"Login"])
    {
        [alert show];
        NSDictionary *params = @{ @"username" : [alertView textFieldAtIndex:0].text,
                                  @"password" : [alertView textFieldAtIndex:1].text};
        
        [_apiClient userLogin: params :^(id result, NSError *error) {
            if (error) {[alert dismissWithClickedButtonIndex:0 animated:YES];}
            else {
                [_user setToken:result];
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [self startStop:_buttonStartStop];
            }
        }];
    }
}

- (void)startTimerLoop {
    [self stopTimerLoop];
    [self updateTimeReports];
    _startTimerRequest = [NSTimer scheduledTimerWithTimeInterval:60.0
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
    [_apiClient reports:^(id result, NSError *error) {
        if (result) {
            NSLog(@"%@",result);
            _dayTotalLabel.text   = [self timeConvertor:[result valueForKeyPath:@"daily"]];
            _weekTotalLabel.text  = [self timeConvertor:[result valueForKeyPath:@"weekly"]];
            _monthTotalLabel.text = [self timeConvertor:[result valueForKeyPath:@"monthly"]];
            _progressBar.progress = [self progressBarConvert:[result valueForKeyPath:@"daily"]];
        }
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
