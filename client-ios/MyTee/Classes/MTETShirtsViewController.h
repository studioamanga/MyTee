//
//  MTETShirtsViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTESettingsViewController.h"
#import "MTELoginViewController.h"
#import "AQGridViewController.h"

@class MTESyncManager;
@class MTETShirtExplorer;
@class MTETShirtViewController;

@interface MTETShirtsViewController : AQGridViewController <MTESettingsViewDelegate, MTELoginViewDelegate>

@property (strong, nonatomic) MTESyncManager * syncManager;
@property (strong, nonatomic) MTETShirtExplorer * tshirtExplorer;

@property (strong, nonatomic) MTETShirtViewController * detailViewController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem * settingsBarButtonItem;

- (void)shouldSyncNow:(id)sender;
- (void)syncStarted:(id)sender;
- (void)syncFinished:(id)sender;
- (void)syncFailed:(id)sender;

- (void)startSpinningAnimation;
- (IBAction)didPressSettingsBarButtonItem:(id)sender;

@end
