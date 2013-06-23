//
//  MTESettingsViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 2/15/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTESettingsViewController;
@class MTESyncManager;

@protocol MTESettingsViewDelegate <NSObject>

- (void)settingsViewControllerShouldClose:(MTESettingsViewController*)settingsViewController;
- (void)settingsViewControllerShouldSyncNow:(MTESettingsViewController*)settingsViewController;
- (void)settingsViewControllerShouldLogOut:(MTESettingsViewController*)settingsViewController;

@end

@interface MTESettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel * emailLabel;

@property (weak, nonatomic) id <MTESettingsViewDelegate> delegate;

@property (strong, nonatomic) MTESyncManager * syncManager;

- (IBAction)didPressDone:(id)sender;
- (IBAction)didPressCancel:(id)sender;

- (void)updateDidStart;

@end
