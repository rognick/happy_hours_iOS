//
//  ReminderBeginningWorkingViewController.h
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 8/6/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderBeginningWorkingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveClearButtonTitle;

@property (strong, nonatomic) NSString *reminderName;

@end
