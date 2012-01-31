//
//  MTESettingsViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 1/29/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTESettingsViewController.h"

#import "MTESyncManager.h"

@implementation MTESettingsViewController

@synthesize emailTextField;
@synthesize passwordTextField;

#define MTE_HUD_HIDE_DELAY 2
#define MTE_HUD_IMAGE_SUCCESS @"19-check"
#define MTE_HUD_IMAGE_ERROR @"20-no"

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    emailTextField.text = [MTESyncManager emailFromKeychain];
    passwordTextField.text = [MTESyncManager passwordFromKeychain];
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
    
    [emailTextField becomeFirstResponder];
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
                [emailTextField becomeFirstResponder];
                break;
            case 1:
                [passwordTextField becomeFirstResponder];
                break;
        }
    }
    if(indexPath.section==1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (![emailTextField text] || [[emailTextField text] isEqualToString:@""])
        {
            [emailTextField becomeFirstResponder];
        }
        else if (![passwordTextField text] || [[passwordTextField text] isEqualToString:@""])
        {
            [passwordTextField becomeFirstResponder];
        }
        else
        {
            if ([emailTextField isFirstResponder])
                [emailTextField resignFirstResponder];
            if ([passwordTextField isFirstResponder])
                [passwordTextField resignFirstResponder];
        
            [self startAuthenticatingWithEmail:[emailTextField text] password:[passwordTextField text]];
        }
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

#pragma mark - 

- (void)startAuthenticatingWithEmail:(NSString*)email password:(NSString*)password
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
            NSUInteger status = [(NSHTTPURLResponse*)response statusCode];
            
            if (status==200)
            {
                authenticationSuccessful = YES;
                
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
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
