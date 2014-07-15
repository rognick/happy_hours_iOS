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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _defaults = [NSUserDefaults standardUserDefaults];
    

    if ([_defaults stringForKey:SERVER_IP]) {
        _serverIP.text = [_defaults stringForKey:SERVER_IP];
        _serverPort.text = [_defaults stringForKey:SERVER_PORT];
        _serverIP.enabled = NO;
        _serverPort.enabled = NO;
        _saveButton.title = @"Edit";
        NSLog(@"%@",[_defaults stringForKey:SERVER_IP]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(UIBarButtonItem *)sender {
    
    if ([_saveButton.title isEqualToString:@"Save"]) {
        [_defaults setObject:_serverIP.text forKey:SERVER_IP];
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
