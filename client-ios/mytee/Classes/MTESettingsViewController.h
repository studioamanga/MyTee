//
//  MTESettingsViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 1/29/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MTESettingsViewController : UITableViewController <UITextFieldDelegate, MBProgressHUDDelegate>
{
    BOOL authenticationSuccessful;    
}

@property (weak, nonatomic) IBOutlet UITextField * emailTextField;
@property (weak, nonatomic) IBOutlet UITextField * passwordTextField;

- (void)startAuthenticatingWithEmail:(NSString*)email password:(NSString*)password;

@end
