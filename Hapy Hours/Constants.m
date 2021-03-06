//
//  Constants.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/14/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString* const KEY_TIMER_ON    = @"TIMER_ON";
NSString* const SERVICE_NAME    = @"com.winify.Happy-Hours";
NSString* const SERVER_HOST     = @"SERVER_HOST";
NSString* const SERVER_PORT     = @"SERVER_PORT";
NSString* const TOKEN           = @"TOKEN";
NSString* const REMAINDER_START = @"REMAINDER_START";
NSString* const REMAINDER_STOP  = @"REMAINDER_STOP";

/*------------Server errors-----------------------------*/
NSString* const SERVER_SESSION_EXPIRY = @"SessionExpiry";
NSString* const SERVER_TIMER_ON       = @"TimerOn";
NSString* const SERVER_TIMER_OFF      = @"TimerOff";
NSString* const ERROR_UNDEFINED       = @"Incorrect username or password";

@end
