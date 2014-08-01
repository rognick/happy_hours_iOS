//
//  ServerSettingsViewController.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/15/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *serverIP;
@property (weak, nonatomic) IBOutlet UITextField *serverPort;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end
