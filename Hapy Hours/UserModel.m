//
//  UserModel.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/22/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "UserModel.h"
#import "Keychain.h"
#import "Constants.h"

@interface UserModel()

@property (strong, atomic) Keychain *keychain;

@end

@implementation UserModel
@synthesize keychain;

- (instancetype)init
{
    self = [super init];
    if (self) {    
        keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
    }
    return self;
}

#pragma Token
- (void)setToken:(NSDictionary*)dictionary {
    [self removeToken];
    NSString *token = [dictionary valueForKey:@"token"];
    NSData *value = [token dataUsingEncoding:NSUTF8StringEncoding];

    [keychain insert:TOKEN :value];
}

- (void)removeToken {
    [keychain remove:TOKEN];
}

- (NSDictionary*)getToken {
    return  @{ @"token" : [[NSString alloc] initWithData:[keychain find:TOKEN] encoding:NSUTF8StringEncoding]};
}

- (BOOL)isValidToken {
    NSData *token = [keychain find:TOKEN];

    if(token == nil) {
        return false;
    } else {
        return true;
    }
}

@end
