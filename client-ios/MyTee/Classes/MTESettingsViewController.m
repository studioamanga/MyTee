//
//  MTESettingsViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 2/15/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTESettingsViewController.h"

#import "MTESyncManager.h"
#import "MTESettingsManager.h"

@implementation MTESettingsViewController

@synthesize emailLabel;
@synthesize lastSyncLabel;
@synthesize remindersTimeCell;
@synthesize syncNowCell;
@synthesize logoutCell;
@synthesize remindersSwitch;

@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString * email = [MTESyncManager emailFromKeychain];
    if (email)
    {
        self.emailLabel.text = email;
        self.lastSyncLabel.text = @"what?";
    }
    else
    {
        self.emailLabel.text = @"You are not logged in";
        self.lastSyncLabel.text = @"";
    }
    
    self.remindersSwitch.on = [MTESettingsManager isRemindersActive];
    [self remindersSwitchValueDidChange:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEmailLabel:nil];
    [self setLastSyncLabel:nil];
    [self setSyncNowCell:nil];
    [self setLogoutCell:nil];
    [self setRemindersTimeCell:nil];
    [self setRemindersSwitch:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)remindersSwitchValueDidChange:(id)sender
{
    if (self.remindersSwitch.isOn)
    {
        [UIView animateWithDuration:0.33 animations:^{
            self.remindersTimeCell.textLabel.textColor = [UIColor blackColor];
            self.remindersTimeCell.imageView.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.33 animations:^{
            self.remindersTimeCell.textLabel.textColor = [UIColor grayColor];
            self.remindersTimeCell.imageView.alpha = 0.5;
        }];
    }
}

- (IBAction)didPressDone:(id)sender
{
    [MTESettingsManager setRemindersActive:self.remindersSwitch.isOn];
    
    [delegate settingsViewControllerShouldClose:self];
}

- (IBAction)didPressCancel:(id)sender
{
    [delegate settingsViewControllerShouldClose:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
