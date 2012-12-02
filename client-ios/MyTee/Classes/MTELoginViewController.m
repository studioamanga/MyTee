//
//  MTELoginViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 1/29/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTELoginViewController.h"

#import "MTESyncManager.h"

#import "MTEConstView.h"

@implementation MTELoginViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailTextField.text = [MTESyncManager emailFromKeychain];
    self.passwordTextField.text = [MTESyncManager passwordFromKeychain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.emailTextField becomeFirstResponder];
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
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
    if(indexPath.section==1)
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
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

#pragma mark - 

- (void)startAuthenticatingWithEmail:(NSString *)email password:(NSString *)password
{
    __block MBProgressHUD * progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.delegate = self;
    
    progressHUD.dimBackground = YES;
    progressHUD.labelText = @"Authenticating...";
    
    authenticationSuccessful = NO;
    
    NSURLRequest * urlRequest = [MTESyncManager requestForAuthenticatingWithEmail:email password:password];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse*response, NSData*data, NSError*error){
        if(response)
        {
            authenticationSuccessful = [MTESyncManager authenticationResponseIsSuccessful:(NSHTTPURLResponse*)response];
            
            if (authenticationSuccessful)
            {
                [MTESyncManager storeEmail:email password:password];
                
                progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_SUCCESS]];
                progressHUD.mode = MBProgressHUDModeCustomView;
                progressHUD.labelText = @"Authentication Successful!";
                progressHUD.detailsLabelText = nil;
                
                [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
            }
            else
            {
                progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_ERROR]];
                progressHUD.mode = MBProgressHUDModeCustomView;
                progressHUD.labelText = @"Authentication Error";
                progressHUD.detailsLabelText = @"Please check your credentials";
            
                [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
            }
        }
        else
        {
            progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_ERROR]];
            progressHUD.mode = MBProgressHUDModeCustomView;
            progressHUD.labelText = @"Authentication Error";
            progressHUD.detailsLabelText = @"Please check your connection";
            
            [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
        }
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (authenticationSuccessful)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate loginViewControllerDidLoggedIn:self];
    }
}

@end
