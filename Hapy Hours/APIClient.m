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
        NSLog(@"%@",error);
        [self showAlerts:@"Error to Log Out" :error];
        if (block) block(nil, error);
    }];
}


- (void)curentTime: curentTime complete:(void(^)(id result, NSError *error))block {
    
    __block NSString *result;
    
    NSDictionary *params = @{ @"token" : [user getToken]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/time"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        result = [responseObject valueForKey:@"time"];
        if (block) block(result, nil);
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlerts:@"Error get curent time" :error];
        if (block) block(nil, error);
        
    }];
}

- (void)start: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [user getToken]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/start"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_defaults setBool:true forKey:KEY_TIMER_ON];
        [_defaults synchronize];
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlerts:@"Error to Start" :error];
        [_defaults setBool:false forKey:KEY_TIMER_ON];
        [_defaults synchronize];
        if (block) block(nil, error);
        
    }];
}

- (void)stop: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [user getToken]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/stop"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_defaults setBool:false forKey:KEY_TIMER_ON];
        [_defaults synchronize];
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlerts:@"Error to Stop" :error];
        if (block) block(nil, error);
    }];
}

- (void)reports: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [user getToken]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/statistic"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlerts:@"Server Error" :error];
        if (block) block(nil, error);
    }];
}

- (void)showAlerts: (NSString *)title :(NSError *)error{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
