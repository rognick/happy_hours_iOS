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
#import "MainController.h"


@interface APIClient ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation APIClient
@synthesize manager;
@synthesize baseURL;

- (APIClient*)init {
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *stringURL = [NSString stringWithFormat: @"http://%@:%@",[_defaults stringForKey:SERVER_HOST],
                                                                      [_defaults stringForKey:SERVER_PORT]];
    baseURL = [NSURL URLWithString:stringURL];
    manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:baseURL];
    return self;
}

- (void)userLogin:(NSDictionary *)params
          success:(void(^)(id response))success
          failure:(void(^)(NSError *error))failure
{
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:@"/login" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success(responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([operation.responseString isEqualToString:ERROR_UNDEFINED]) {
                failure(nil);
            } else {
                failure(error);
            }
        }];
}

- (void)userLogOut:(NSDictionary *)params
           success:(void(^)(id response))success
           failure:(void(^)(NSError *error))failure
     sessionExpiry:(void(^)())sessionExpiry
{
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/logout"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.responseString isEqualToString:SERVER_SESSION_EXPIRY]) {
            sessionExpiry();
        } else {
            failure(error);
        }
    }];
}

- (void)startTimer:(NSDictionary *)params
           success:(void(^)(id response))success
           failure:(void(^)(NSError *error))failure
     sessionExpiry:(void(^)())sessionExpiry
{
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/start"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.responseString isEqualToString:SERVER_SESSION_EXPIRY]) {
            sessionExpiry();
        } else if ([operation.responseString isEqualToString:SERVER_TIMER_ON]){
            failure(nil);
        } else {
            failure(error);
        }
    }];
}

- (void)stopTimer:(NSDictionary *)params
          success:(void(^)(id response))success
          failure:(void(^)(NSError *error))failure
    sessionExpiry:(void(^)())sessionExpiry
{
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/stop"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([operation.responseString isEqualToString:SERVER_SESSION_EXPIRY]) {
            sessionExpiry();
        } else if ([operation.responseString isEqualToString:SERVER_TIMER_OFF]){
            failure(nil);
        } else {
            failure(error);
        }
    }];
}

- (void)reports:(NSDictionary *)params
        success:(void(^)(id response))success
        failure:(void(^)(NSError *error))failure
  sessionExpiry:(void(^)())sessionExpiry
{
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:@"/statistic"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {        
        if ([operation.responseString isEqualToString:SERVER_SESSION_EXPIRY]) {
            sessionExpiry();
        } else {
            failure(error);
        }
    }];
}

@end
