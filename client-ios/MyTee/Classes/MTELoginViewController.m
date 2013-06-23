//
//  MTELoginViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 1/29/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTELoginViewController.h"

#import "MTEConstView.h"
#import "MTEMyTeeAPIClient.h"
#import "MTEAuthenticationManager.h"

@implementation MTELoginViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    self.emailTextField.text = [MTEAuthenticationManager emailFromKeychain];
    self.passwordTextField.text = [MTEAuthenticationManager passwordFromKeychain];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.emailTextField becomeFirstResponder];
}

#pragma mark - Table view delegate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                [self.emailTextField becomeFirstResponder];
                break;
            case 1:
                [self.passwordTextField becomeFirstResponder];
                break;
        }
    }
    else if (indexPath.section == 1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (![self.emailTextField text] || [[self.emailTextField text] isEqualToString:@""])
        {
            [self.emailTextField becomeFirstResponder];
        }
        else if (![self.passwordTextField text] || [[self.passwordTextField text] isEqualToString:@""])
        {
            [self.passwordTextField becomeFirstResponder];
        }
        else
        {
            if ([self.emailTextField isFirstResponder])
                [self.emailTextField resignFirstResponder];
            if ([self.passwordTextField isFirstResponder])
                [self.passwordTextField resignFirstResponder];
        
            [self startAuthenticatingWithEmail:[self.emailTextField text] password:[self.passwordTextField text]];
        }
    }
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - Actions

- (void)startAuthenticatingWithEmail:(NSString *)email password:(NSString *)password
{
    __block MBProgressHUD * progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.delegate = self;
    
    progressHUD.dimBackground = YES;
    progressHUD.labelText = @"Authenticating...";
    
    self.authenticationSuccessful = NO;
    
    [[MTEMyTeeAPIClient sharedClient] sendAuthenticationRequestWithUsername:email password:password success:^{
        self.authenticationSuccessful = YES;
        [MTEAuthenticationManager storeEmail:email password:password];
        
        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_SUCCESS]];
        progressHUD.mode = MBProgressHUDModeCustomView;
        progressHUD.labelText = @"Authentication Successful!";
        progressHUD.detailsLabelText = nil;
        
        [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
    } failure:^{
        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_ERROR]];
        progressHUD.mode = MBProgressHUDModeCustomView;
        progressHUD.labelText = @"Authentication Error";
        progressHUD.detailsLabelText = @"Please check your credentials";
        
        [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
    }];
}

#pragma mark - Progress HUD delegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (self.authenticationSuccessful)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate loginViewControllerDidLoggedIn:self];
    }
}

@end
