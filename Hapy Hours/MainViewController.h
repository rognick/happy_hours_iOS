//
//  MainViewController.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/12/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISwitch *loginSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *timerSwitch;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end
