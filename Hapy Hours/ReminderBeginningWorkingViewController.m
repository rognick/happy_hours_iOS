//
//  ReminderBeginningWorkingViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 8/6/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "ReminderBeginningWorkingViewController.h"
#import "Constants.h"

@interface ReminderBeginningWorkingViewController ()

@end

@implementation ReminderBeginningWorkingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
        NSDictionary *userInfo = notification.userInfo;
        if ([[userInfo objectForKey:_reminderName] isEqualToString:[userInfo objectForKey:_reminderName]]){
            [_saveClearButtonTitle setTitle:@"Clear"];
            [_message setText:notification.alertBody];
            [_datePicker setDate:notification.fireDate animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)saveReminder {
    // Get the current date
    NSDate *pickerDate = [self.datePicker date];
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = pickerDate;
    localNotification.alertBody = self.message.text;
    localNotification.alertAction = nil;//@"Start Timer";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSMinuteCalendarUnit;//NSDayCalendarUnit;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.message.text forKey:_reminderName];
    localNotification.userInfo = userInfo;
    
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [self showAllert:@"Save. Success"];
}

- (void)clearReminder {

    BOOL done = NO;
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy]){
        NSDictionary *userInfo = notification.userInfo;
        if ([[userInfo objectForKey:_reminderName] isEqualToString:[userInfo objectForKey:_reminderName]]){
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            [self showAllert:@"Clear. Success"];
            done = YES;
        }
    }
    if (!done){[self showAllert:@"Clear. Error"];}
}

- (IBAction)saveClearButton:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Clear"]) {
        [self clearReminder];
        [_saveClearButtonTitle setTitle:@"Save"];
        
    } else if ([sender.title isEqualToString:@"Save"]) {
        [self saveReminder];
        [_saveClearButtonTitle setTitle:@"Clear"];
    }
}

- (void)showAllert:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
