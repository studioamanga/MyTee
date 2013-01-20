//
//  MTESettingsViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 2/15/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTESettingsViewController.h"

#import "MTEAuthenticationManager.h"
#import "MTESettingsManager.h"
#import "MTESettingCell.h"
#import "MTESettingSwitchCell.h"

enum MTESettingsViewSections {
    MTESettingsViewSectionReminders = 0,
    MTESettingsViewSectionSyncNow,
    MTESettingsViewSectionLogOut,
    MTESettingsViewNumberOfSections
    };

@interface MTESettingsViewController () <UIAlertViewDelegate>

- (IBAction)remindersSwitchValueDidChange:(UISwitch *)sender;

@end

@implementation MTESettingsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 128, 1)]];
        self.navigationItem.leftBarButtonItem = spaceBarButtonItem;
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"linen-darker-bar"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"linen-darker-bar-landscape"] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    
    NSString * email = [MTEAuthenticationManager emailFromKeychain];
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
    
    [self updateSyncDateLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDidStart) name:MTE_NOTIFICATION_SYNC_STARTED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSyncDateLabel) name:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncFailed) name:MTE_NOTIFICATION_SYNC_FAILED object:nil];
    
//    if ([self.syncManager isSyncing])
//    {
//        [self.syncActivityIndicator startAnimating];
//        self.lastSyncLabel.text = @"Syncing...";
//    }
//    else
//    {
//        [self.syncActivityIndicator stopAnimating];
//        [self updateSyncDateLabel];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTE_NOTIFICATION_SYNC_STARTED object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTE_NOTIFICATION_SYNC_FAILED object:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? 128 : 380, 1)]];
        self.navigationItem.leftBarButtonItem = spaceBarButtonItem;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MTESettingsViewNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case MTESettingsViewSectionReminders:
            return 2;
        case MTESettingsViewSectionSyncNow:
        case MTESettingsViewSectionLogOut:
            return 1;
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case MTESettingsViewSectionReminders:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"MTESettingsReminderSwitchCell" forIndexPath:indexPath];
                    ((MTESettingSwitchCell *)cell).switchControl.on = [MTESettingsManager isRemindersActive];
                    [((MTESettingSwitchCell *)cell).switchControl removeTarget:self action:@selector(remindersSwitchValueDidChange:) forControlEvents:UIControlEventValueChanged];
                    [((MTESettingSwitchCell *)cell).switchControl addTarget:self action:@selector(remindersSwitchValueDidChange:) forControlEvents:UIControlEventValueChanged];
                    break;
                case 1:
                    cell = [tableView dequeueReusableCellWithIdentifier:@"MTESettingsReminderTimeCell" forIndexPath:indexPath];
                    ((MTESettingCell *)cell).label.text = [NSString stringWithFormat:@"Everyday at %d AM", [MTESettingsManager remindersHour]];
                    for (UIView *subview in cell.contentView.subviews)
                        subview.alpha = ([MTESettingsManager isRemindersActive]) ? 1 : 0.5;
                    break;
            }
            break;
        }
        case MTESettingsViewSectionSyncNow:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MTESettingsActionCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Sync Now";
            break;
        case MTESettingsViewSectionLogOut:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MTESettingsActionCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Log Out";
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case MTESettingsViewSectionReminders:
            break;
        case MTESettingsViewSectionSyncNow:
//            [self.syncManager startSync];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        case MTESettingsViewSectionLogOut:
//            if (!self.syncManager.isSyncing)
//            {
//                [tableView deselectRowAtIndexPath:indexPath animated:YES];
//                [[[UIAlertView alloc] initWithTitle:@"Logging Out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil] show];
//            }
            break;
    }
}

#pragma mark - Switch delegate

- (IBAction)remindersSwitchValueDidChange:(UISwitch *)sender
{
    UITableViewCell *reminderTimeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:MTESettingsViewSectionReminders]];
    
    if (sender.isOn)
    {
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *subview in reminderTimeCell.contentView.subviews)
                subview.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *subview in reminderTimeCell.contentView.subviews)
                subview.alpha = 0.5;
        }];
    }

    [MTESettingsManager setRemindersActive:sender.isOn];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
        [self.delegate settingsViewControllerShouldLogOut:self];
}

- (void)updateSyncDateLabel
{
//    NSDate * syncDate = [MTESyncManager lastSyncDate];
//    if (syncDate) 
//    {
//        NSDateFormatter * dateFormatter = [NSDateFormatter new];
//        dateFormatter.doesRelativeDateFormatting = YES;
//        dateFormatter.dateStyle = NSDateFormatterLongStyle;
//        dateFormatter.timeStyle = NSDateFormatterShortStyle;
//        self.lastSyncLabel.text = [@"Last Sync: " stringByAppendingString:[dateFormatter stringFromDate:syncDate]];
//    }
//    else 
//    {
//        self.lastSyncLabel.text = @"Never Synchronized";
//    }
    
    [self.syncActivityIndicator stopAnimating];
}

- (void)syncFailed
{
    [self.syncActivityIndicator stopAnimating];
}

- (void)updateDidStart
{
    [self.syncActivityIndicator startAnimating];
    self.lastSyncLabel.text = @"Syncing...";
}

- (IBAction)didPressDone:(id)sender
{
    [self.delegate settingsViewControllerShouldClose:self];
}

- (IBAction)didPressCancel:(id)sender
{
    [self.delegate settingsViewControllerShouldClose:self];
}

@end
