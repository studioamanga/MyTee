//
//  MTESettingsViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 2/15/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTESettingsViewController.h"

#import "MTESyncManager.h"

@implementation MTESettingsViewController

@synthesize emailLabel;
@synthesize lastSyncLabel;
@synthesize syncNowCell;
@synthesize logoutCell;

@synthesize delegate;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEmailLabel:nil];
    [self setLastSyncLabel:nil];
    [self setSyncNowCell:nil];
    [self setLogoutCell:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)didPressDone:(id)sender
{
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
