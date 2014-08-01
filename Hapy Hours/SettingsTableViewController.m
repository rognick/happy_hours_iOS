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
#import "BaseViewController.h"

@interface SettingsTableViewController ()

@property (strong, nonatomic) APIClient *apiClient;
@property (strong, nonatomic) UserModel *user;

@end

@implementation SettingsTableViewController
@synthesize apiClient;
@synthesize user;

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
    user = [[UserModel alloc] init];
    apiClient = [[APIClient alloc] init];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:{
            
            BaseViewController *base = [[BaseViewController alloc] init];
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
            
            [apiClient userLogOut:[user getToken] success:^(id response) {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [user removeToken];
            } failure:^(NSError *error) {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [base showServerError:@"Error LogOut" :error];
            } sessionExpiry:^{
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [base sessionExpiry];
            }];
            
        }break;
            
        default:
            break;
    }
}
@end
