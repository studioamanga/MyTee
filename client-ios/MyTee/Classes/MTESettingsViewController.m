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

@interface MTESettingsViewController () <UIActionSheetDelegate>

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
    self.emailLabel.text = (email) ? email : @"You are not logged in";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.delegate settingsViewControllerShouldSyncNow:self];
            break;
            
        case MTESettingsViewSectionLogOut:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [[[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log Out" otherButtonTitles:nil] showInView:self.view];
            break;
    }
}

#pragma mark - Switch delegate

- (IBAction)remindersSwitchValueDidChange:(UISwitch *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:MTESettingsViewSectionReminders];
    UITableViewCell *reminderTimeCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *subview in reminderTimeCell.contentView.subviews)
            subview.alpha = (sender.isOn) ? 1 : 0.5;
    }];

    [MTESettingsManager setRemindersActive:sender.isOn];
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
        [self.delegate settingsViewControllerShouldLogOut:self];
}

#pragma mark - Sync

- (void)syncFailed
{
}

- (void)updateDidStart
{
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
