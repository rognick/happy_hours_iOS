//
//  ServerSettingsViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/15/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "ServerSettingsViewController.h"
#import "Constants.h"

@interface ServerSettingsViewController ()

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation ServerSettingsViewController

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
    
    _defaults = [NSUserDefaults standardUserDefaults];

    if ([_defaults stringForKey:SERVER_HOST]) {
        _serverIP.text = [_defaults stringForKey:SERVER_HOST];
        _serverPort.text = [_defaults stringForKey:SERVER_PORT];
        _serverIP.enabled = NO;
        _serverPort.enabled = NO;
        _saveButton.title = @"Edit";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
    if ([_saveButton.title isEqualToString:@"Save"]) {
        [_defaults setObject:_serverIP.text forKey:SERVER_HOST];
        [_defaults setObject:_serverPort.text forKey:SERVER_PORT];
        [_defaults synchronize];
         _saveButton.title = @"Edit";
        _serverIP.enabled = NO;
        _serverPort.enabled = NO;
    } else {
        _serverIP.enabled = YES;
        _serverPort.enabled = YES;
        _saveButton.title = @"Save";
    }
}

@end
