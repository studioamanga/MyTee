//
//  MTELoginViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 1/29/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MBProgressHUD.h"

@class MTELoginViewController;

@protocol MTELoginViewDelegate <NSObject>

- (void)loginViewControllerDidLoggedIn:(MTELoginViewController*)loginViewController;

@end

@interface MTELoginViewController : UITableViewController <UITextFieldDelegate, MBProgressHUDDelegate>
{
    BOOL authenticationSuccessful;    
}

@property (weak, nonatomic) IBOutlet UITextField * emailTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;

@property (weak, nonatomic) id <MTELoginViewDelegate> delegate;

- (void)startAuthenticatingWithEmail:(NSString*)email password:(NSString*)password;

@end
