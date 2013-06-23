//
//  MTELoginViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 1/29/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MBProgressHUD.h"

@protocol MTELoginViewDelegate;

@interface MTELoginViewController : UITableViewController <UITextFieldDelegate, MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITextField * emailTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;
@property (weak, nonatomic) id <MTELoginViewDelegate> delegate;
@property BOOL authenticationSuccessful;

- (void)startAuthenticatingWithEmail:(NSString*)email password:(NSString*)password;

@end


@protocol MTELoginViewDelegate <NSObject>

- (void)loginViewControllerDidLoggedIn:(MTELoginViewController*)loginViewController;

@end