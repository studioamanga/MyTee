//
//  MTETShirtsViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

@class MTESyncManager;

@interface MTETShirtsViewController : UITableViewController

@property (strong, nonatomic) MTESyncManager * syncManager;

- (void)syncFinished:(id)sender;
- (void)syncFailed:(id)sender;

@end
