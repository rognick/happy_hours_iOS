//
//  UserModel.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/22/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

- (BOOL)isValidToken;
- (void)setToken: (NSDictionary*)dictionary;
- (NSString*)getToken;
- (void)removeToken;

@end
