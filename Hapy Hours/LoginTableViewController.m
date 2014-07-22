//
//  LoginTableViewController.m
//  Hapy Hours
//
//  Created by Nicolae Rogojan on 7/13/14.
//  Copyright (c) 2014 Nicolae Rogojan. All rights reserved.
//

#import "LoginTableViewController.h"
#import "Keychain.h"
#import "Constants.h"


@interface LoginTableViewController ()

@property (strong, nonatomic) Keychain *keychain;

@end

@implementation LoginTableViewController
@synthesize keychain;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userLogin.delegate = self;
    _userPassword.delegate = self;
    
    keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
    NSData *password =[keychain find:@"PASSWORD"];
    NSData *login = [keychain find:@"LOGIN"];
    if(login == nil)
    {
        NSLog(@"Keychain data not found");
    }
    else
    {
        _userLogin.text = [[NSString alloc] initWithData:login encoding:NSUTF8StringEncoding];
        _userPassword.text = [[NSString alloc] initWithData:password encoding:NSUTF8StringEncoding];
        _userLogin.enabled = false;
        _userPassword.enabled = false;
        _singInCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((_singInLabel.enabled) && (indexPath.section == 3)) {
        
        NSString *key =@"LOGIN";
        NSData *value = [_userLogin.text dataUsingEncoding:NSUTF8StringEncoding];
        
        if([keychain insert:key :value])
        {
            NSLog(@"Successfully added Login");
        }
        else
            NSLog(@"Failed to  add Login");
        
        key =@"PASSWORD";
        value = [_userPassword.text dataUsingEncoding:NSUTF8StringEncoding];
        
        if([keychain insert:key :value])
        {
            NSLog(@"Successfully added Password");
        }
        else
            NSLog(@"Failed to  add Password");

        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:LOGIN_SETUP];
        [defaults synchronize];
        _userLogin.enabled = false;
        _userPassword.enabled = false;
    }
}

#pragma Enable SingIn label
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_userPassword.text.length > 0 && _userLogin.text.length > 0 ) {
        _singInLabel.enabled = true;
        _singInCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        _singInLabel.enabled = false;
        _singInCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (_userPassword.text.length > 0 && _userLogin.text.length > 0 ) {
        _singInLabel.enabled = true;
        _singInCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        _singInLabel.enabled = false;
        _singInCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return YES;
}
- (IBAction)editButton:(UIBarButtonItem *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];

    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSData *pass =[keychain find:@"PASSWORD"];
    NSString *password = [[NSString alloc] initWithData:pass encoding:NSUTF8StringEncoding];
    
    if([title isEqualToString:@"OK"])
    {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:password]) {
            [keychain remove:@"PASSWORD"];
            [keychain remove:@"LOGIN"];
            _userLogin.enabled = true;
            _userPassword.enabled = true;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Password"
                                                                message:@"error password try again"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

@end
