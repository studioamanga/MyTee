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
    
    self.remindersTimeCell.textLabel.text = [NSString stringWithFormat:@"Everyday at %d AM", [MTESettingsManager remindersHour]];
    self.remindersSwitch.on = [MTESettingsManager isRemindersActive];
    [self remindersSwitchValueDidChange:nil];
    
    [self updateSyncDateLabel];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSyncDateLabel) 
												 name:MTE_NOTIFICATION_SYNC_FINISHED
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MTE_NOTIFICATION_SYNC_FINISHED
                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];

    return  cell;
}

- (IBAction)remindersSwitchValueDidChange:(id)sender
{
    if (self.remindersSwitch.isOn)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.remindersTimeCell.textLabel.textColor = [UIColor blackColor];
            self.remindersTimeCell.imageView.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.remindersTimeCell.textLabel.textColor = [UIColor grayColor];
            self.remindersTimeCell.imageView.alpha = 0.5;
        }];
    }
}

- (void)updateSyncDateLabel
{
    NSDate * syncDate = [MTESyncManager lastSyncDate];
    if (syncDate) 
    {
        NSDateFormatter * dateFormatter = [NSDateFormatter new];
        dateFormatter.doesRelativeDateFormatting = YES;
        dateFormatter.dateStyle = NSDateFormatterLongStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        
        self.lastSyncLabel.text = [@"Last Sync: " stringByAppendingString:[dateFormatter stringFromDate:syncDate]];
    }
    else 
    {
        self.lastSyncLabel.text = @"Never Synchronized";
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
