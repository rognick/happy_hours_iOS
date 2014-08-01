//
//  APIClient.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/17/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFHTTPRequestOperationManager.h"

@interface APIClient : AFHTTPRequestOperationManager

- (void)userLogin:(NSDictionary *)params
          success:(void(^)(id response))success
          failure:(void(^)(NSError *error))failure;

- (void)userLogOut:(NSDictionary *)params
           success:(void(^)(id response))success
           failure:(void(^)(NSError *error))failure
     sessionExpiry:(void(^)())sessionExpiry;

- (void)startTimer:(NSDictionary *)params
           success:(void(^)(id response))success
           failure:(void(^)(NSError *error))failure
     sessionExpiry:(void(^)())sessionExpiry;

- (void)stopTimer:(NSDictionary *)params
          success:(void(^)(id response))success
          failure:(void(^)(NSError *error))failure
    sessionExpiry:(void(^)())sessionExpiry;

- (void)reports:(NSDictionary *)params
        success:(void(^)(id response))success
        failure:(void(^)(NSError *error))failure
  sessionExpiry:(void(^)())sessionExpiry;

@end
