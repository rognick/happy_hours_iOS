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

@end

@implementation LoginTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userLogin.delegate = self;
    _userPassword.delegate = self;
    
    Keychain * keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
    
    [keychain remove:@"PASSWORD"];
    [keychain remove:@"LOGIN"];

    
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

        Keychain * keychain =[[Keychain alloc] initWithService:SERVICE_NAME withGroup:nil];
        
        NSString *key =@"LOGIN";
        [keychain remove:key];
        NSData * value = [_userLogin.text dataUsingEncoding:NSUTF8StringEncoding];
        
        if([keychain insert:key :value])
        {
            NSLog(@"Successfully added Login");
        }
        else
            NSLog(@"Failed to  add Login");
        
        
        key =@"PASSWORD";
        [keychain remove:key];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
}

@end
