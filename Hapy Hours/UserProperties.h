//
//  UserProperties.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/14/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProperties : NSUserDefaults

-(BOOL) insertString:(NSString *)key :(NSString *)string;
-(BOOL) insertArray:(NSString *)key :(NSArray *)array;
-(BOOL) insertData:(NSString *)key :(NSData *)data;

-(BOOL) updateString:(NSString *)key :(NSString *)string;
-(BOOL) updateArray:(NSString *)key :(NSArray *)array;
-(BOOL) updateData:(NSString *)key :(NSData *)data;

-(BOOL) remove: (NSString*)key;

@end
