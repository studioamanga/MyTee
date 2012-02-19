//
//  MTESettingsViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 2/15/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTESettingsViewController;

@protocol MTESettingsViewDelegate <NSObject>

- (void)settingsViewControllerShouldClose:(MTESettingsViewController*)settingsViewController;
- (void)settingsViewControllerShouldSyncNow:(MTESettingsViewController*)settingsViewController;
- (void)settingsViewControllerShouldLogOut:(MTESettingsViewController*)settingsViewController;

@end

@interface MTESettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel * emailLabel;
@property (weak, nonatomic) IBOutlet UILabel * lastSyncLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *remindersTimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * syncNowCell;
@property (weak, nonatomic) IBOutlet UITableViewCell * logoutCell;
@property (weak, nonatomic) IBOutlet UISwitch * remindersSwitch;

@property (weak, nonatomic) id <MTESettingsViewDelegate> delegate;

- (IBAction)didPressDone:(id)sender;
- (IBAction)didPressCancel:(id)sender;

- (void)updateSyncDateLabel;

@end
