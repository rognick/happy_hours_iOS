//
//  SettingsTableViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/13/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "APIClient.h"
#import "Constants.h"
#import "UserModel.h"

@interface SettingsTableViewController ()

@property (strong, nonatomic) APIClient *apiClient;

@end

@implementation SettingsTableViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    _apiClient = [[APIClient alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout process\nPlease Wait..."
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame= CGRectMake(50, 10, 37, 37);
            activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
            [activityIndicator startAnimating];
            [alert setValue:activityIndicator forKey:@"accessoryView"];
            [alert show];
            
            [_apiClient userLogOut:^(id result, NSError *error) {
                if (error) {
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                } else {
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                }
            }];
        }break;
            
        default:
            break;
    }
}
@end
