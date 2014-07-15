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
