//
//  BaseViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/31/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "BaseViewController.h"
#import "APIClient.h"
#import "MainController.h"

@interface BaseViewController()

@end

@implementation BaseViewController
@synthesize apiClient;
@synthesize user;

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
        apiClient = [[APIClient alloc] init];
        user = [[UserModel alloc] init];
        
        [alert show];
        NSDictionary *params = @{ @"username" : [alertView textFieldAtIndex:0].text,
                                  @"password" : [alertView textFieldAtIndex:1].text};
        [apiClient userLogin:params success:^(id response) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [user setToken:response];
            MainController *main = [[MainController alloc] init];
            [main setTimerLoop];
        } failure:^(NSError *error) {
            if (error) {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [self showServerError:@"Error Login" :error];
            } else {
                [alert dismissWithClickedButtonIndex:0 animated:YES];
                [self showServerError:@"Incorrect username or password" :nil];
            }
        }];
    }
    
    if ([title isEqualToString:@"OK"]) {
        [self showLogin];
    }
}

- (void)showServerError: (NSString *)title :(NSError *)error{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                            message:[error localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
    [alertView show];
}

- (void)sessionExpiry {
    
    [user removeToken];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Session expired"
                                            message:@"You need to start over"
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    [alertView show];
}

@end
