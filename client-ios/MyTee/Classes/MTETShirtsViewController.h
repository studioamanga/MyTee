//
//  MTETShirtsViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

@class MTESyncManager;
@class MTETShirtExplorer;
@class MTETShirtViewController;

@interface MTETShirtsViewController : UITableViewController

@property (strong, nonatomic) MTESyncManager * syncManager;
@property (strong, nonatomic) MTETShirtExplorer * tshirtExplorer;

@property (strong, nonatomic) MTETShirtViewController * detailViewController;

- (void)syncFinished:(id)sender;
- (void)syncFailed:(id)sender;

@end
