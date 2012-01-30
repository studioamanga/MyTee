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
        if ([emailTextField isFirstResponder])
            [emailTextField resignFirstResponder];
        if ([passwordTextField isFirstResponder])
            [passwordTextField resignFirstResponder];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self startAuthenticatingWithEmail:[emailTextField text] password:[passwordTextField text]];
        //[self dismissModalViewControllerAnimated:YES];
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
