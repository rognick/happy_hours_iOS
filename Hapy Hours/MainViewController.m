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
#import "AFHTTPRequestOperationManager.h"


@interface MainViewController ()

@property (strong, nonatomic) NSUserDefaults *defaults;

@end


@implementation MainViewController

@synthesize defaults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setToolbarHidden:NO animated:YES];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    _loginSwitch.on = [defaults boolForKey:KEY_LOGIN];
    _timerSwitch.on = [defaults boolForKey:KEY_TIMER_ON];
    
}
    
- (IBAction)logInSwitch:(UISwitch *)sender {
    
    _timerSwitch.on = sender.on;
    [defaults setBool:sender.on forKey:KEY_LOGIN];
    [defaults synchronize];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://192.168.3.82:9000/users" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
     
    }];
    
    
}

- (IBAction)timerSwitch:(UISwitch *)sender {
    
    if (![defaults boolForKey:KEY_LOGIN]) {
        
        [_timerSwitch setOn:NO animated:YES];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Start Timer"
                                                          message:@"Required login"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
    [defaults setBool:sender.on forKey:KEY_TIMER_ON];
    [defaults synchronize];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
