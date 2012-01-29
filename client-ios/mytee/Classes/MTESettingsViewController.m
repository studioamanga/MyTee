//
//  MTESettingsViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 1/29/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTESettingsViewController.h"

@implementation MTESettingsViewController

@synthesize emailTextField;
@synthesize passwordTextField;

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
                [emailTextField becomeFirstResponder];
                break;
            case 1:
                [passwordTextField becomeFirstResponder];
                break;
        }
    }
    if(indexPath.section==1)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==emailTextField)
    {
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

@end
