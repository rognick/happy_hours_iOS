//
//  APIClient.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/17/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "APIClient.h"
#import "Keychain.h"
#import "Constants.h"
#import "UserModel.h"


@interface APIClient ()

@property (strong, nonatomic) UserModel *user;
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation APIClient
@synthesize user;
@synthesize manager;
@synthesize baseURL;

- (APIClient*)init {
    
    user = [[UserModel alloc]init];
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *stringURL = [NSString stringWithFormat: @"http://%@:%@",[_defaults stringForKey:SERVER_HOST],
                                                                      [_defaults stringForKey:SERVER_PORT]];
    baseURL = [NSURL URLWithString:stringURL];
    manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:baseURL];
    return self;
}

- (void)userLogin:(NSDictionary *)params :(void(^)(id result, NSError *error))block;{

        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (block) block(responseObject, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [user removeToken];
            [self showAlerts:@"Error Login" :error];
            if (block) block(nil, error);
        }];
}

- (void)userLogOut: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [user getToken]};
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/logout"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [user removeToken];
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#warning ---
        NSLog(@"LogOut %@",operation.responseString);
        
        if ([operation.responseString isEqualToString:@"Error: cant find user with such token"]) {
            [self sessionExpiry];
            block(nil, error);
        } else {
            [self showAlerts:@"Error to Log Out" :error];
        if (block) block(nil, error);
        }
    }];
}

- (void)start: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [user getToken]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/start"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#warning --
        NSLog(@"Start %@",operation.responseString);
        if ([operation.responseString isEqualToString:@"Error: cant find user with such token"]) {
            [self sessionExpiry];
        } else if ([operation.responseString isEqualToString:@"Timer is already running"]){
            if (block) block(nil, nil);
        } else {
            [self showAlerts:@"Error to Start" :error];
            if (block) block(nil, error);
        }
    }];
}

- (void)stop: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [user getToken]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/stop"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#warning --
        NSLog(@"Stop %@",operation.responseString);
        
        if ([operation.responseString isEqualToString:@"Error: cant find user with such token"]) {
            [self sessionExpiry];
        } else if ([operation.responseString isEqualToString:@"Timer is not running"]){
            block(nil, nil);
        } else {
            [self showAlerts:@"Error to Stop" :error];
            block(nil, error);
        }
    }];
}

- (void)reports: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [user getToken]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/statistic"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#warning --
        NSLog(@"Reports %@",operation.responseString);
        
        if ([operation.responseString isEqualToString:@"Error: cant find user with such token"]) {
            [self sessionExpiry];
            block(nil, error);
        } else {
            [self showAlerts:@"Server Error" :error];
            if (block) block(nil, error);
        }
    }];
}

- (void)showAlerts: (NSString *)title :(NSError *)error{
    
    if (_alertView.isVisible) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    _alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [_alertView show];
}

- (void)sessionExpiry {
    [user removeToken];
    
    if (_alertView.isVisible) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    _alertView = [[UIAlertView alloc] initWithTitle:@"Session token expired"
                                            message:@"You need to start over"
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil];
    [_alertView show];
}

@end
