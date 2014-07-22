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


@interface APIClient ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, nonatomic) NSURL *baseURL;


@end

@implementation APIClient

@synthesize baseURL;
@synthesize manager;

-(APIClient*)init {
    _defaults = [NSUserDefaults standardUserDefaults];
    
//    NSString *stringURL = [NSString stringWithFormat: @"http://%@:%@",[_defaults stringForKey:SERVER_HOST],
//                                                                      [_defaults stringForKey:SERVER_PORT]];
//    baseURL = [NSURL URLWithString:stringURL];
//    baseURL = [NSURL URLWithString:@"http://localhost:9000"];
    baseURL = [NSURL URLWithString:@"http://192.168.3.93:9000"];
    manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:baseURL];
    return self;
}

-(void) userLogin: (void(^)(id result, NSError *error))block;{
    
    Keychain * keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
    
    NSData *password =[keychain find:@"PASSWORD"];
    NSData *login = [keychain find:@"LOGIN"];
    if(login == nil)
    {
        [self showAlerts:@"Login not found" :nil];
        NSLog(@"Login not found");
    }
    else
    {
        NSDictionary *params = @{ @"username" : [[NSString alloc] initWithData:login encoding:NSUTF8StringEncoding],
                                  @"password" : [[NSString alloc] initWithData:password encoding:NSUTF8StringEncoding]};
        
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Json %@",responseObject);
            if (![[responseObject valueForKeyPath:@"token"] isEqualToString:@""]) {
                [_defaults setObject:[responseObject valueForKeyPath:@"token"] forKey:TOKEN];
                [_defaults setBool:true forKey:KEY_LOGIN];
                [_defaults synchronize];
            }
            if (block) block(responseObject, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlerts:@"Error Login" :error];
            [_defaults setBool:false forKey:KEY_LOGIN];
            [_defaults synchronize];
            NSLog(@"Error %@",error);
            if (block) block(nil, error);
        }];
    }
}

-(void) userLogOut: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [_defaults stringForKey:TOKEN]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/logout"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_defaults setBool:false forKey:KEY_TIMER_ON];
        [_defaults setBool:false forKey:KEY_LOGIN];
        [_defaults synchronize];
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self showAlerts:@"Error to Log Out" :error];
        if (block) block(nil, error);
    }];
}


-(void) curentTime: curentTime complete:(void(^)(id result, NSError *error))block {
    
    __block NSString *result;
    
    NSDictionary *params = @{ @"token" : [_defaults stringForKey:TOKEN]};
    
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

-(void) start: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [_defaults stringForKey:TOKEN]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/start"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_defaults setBool:true forKey:KEY_TIMER_ON];
        [_defaults synchronize];
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error ==>  %@",error);
        [self showAlerts:@"Error to Start" :error];
        [_defaults setBool:false forKey:KEY_TIMER_ON];
        [_defaults synchronize];
        if (block) block(nil, error);
        
    }];
}

-(void) stop: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [_defaults stringForKey:TOKEN]};
    
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

-(void) reports: (void(^)(id result, NSError *error))block {
    
    NSDictionary *params = @{ @"token" : [_defaults stringForKey:TOKEN]};
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/statistic"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (block) block(responseObject, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlerts:@"Server Error" :error];
        if (block) block(nil, error);
    }];
}



-(void) showAlerts: (NSString *)title :(NSError *)error{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
