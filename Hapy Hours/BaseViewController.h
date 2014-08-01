//
//  BaseViewController.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/31/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "APIClient.h"

@interface BaseViewController : UIViewController

@property (strong, nonatomic) APIClient *apiClient;
@property (strong, nonatomic) UserModel *user;

- (void)showServerError: (NSString *)title :(NSError *)error;
- (void)showLogin;
- (void)sessionExpiry;

@end
