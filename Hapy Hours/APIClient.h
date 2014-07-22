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

-(void) userLogin: (void(^)(id result, NSError *error))block;

-(void) userLogOut: (void(^)(id result, NSError *error))block;

-(void) curentTime: curentTime complete:(void(^)(id result, NSError *error))block;

-(void) start: (void(^)(id result, NSError *error))block;

-(void) stop: (void(^)(id result, NSError *error))block;

-(void) reports: (void(^)(id result, NSError *error))block;

@end
