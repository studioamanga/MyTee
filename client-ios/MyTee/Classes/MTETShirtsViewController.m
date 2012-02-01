//
//  MTETShirtsViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTETShirtsViewController.h"

#import "MTESyncManager.h"

#import "MTETShirt.h"
#import "MTETShirtExplorer.h"

#import "MBProgressHUD.h"
#import "MTEConstView.h"

@implementation MTETShirtsViewController

@synthesize syncManager;
@synthesize tshirtExplorer;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.syncManager = [MTESyncManager new];
    [self.syncManager setupSyncManager];
    
    self.tshirtExplorer = [MTETShirtExplorer new];
    NSManagedObjectContext * context = [[[RKObjectManager sharedManager] objectStore] managedObjectContext];
    [self.tshirtExplorer setupFetchedResultsControllerWithContext:context];
    [self.tshirtExplorer updateData];

    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncFinished:) name:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncFailed:) name:MTE_NOTIFICATION_SYNC_FAILED object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString * email = [MTESyncManager emailFromKeychain];
    if (!email)
    {
        [self performSegueWithIdentifier:@"MTELoginSegue" sender:nil];
    }
    else
    {
        [self.syncManager startSync];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MTELoginSegue"])
    {
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tshirtExplorer numberOfTShirts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MTETShirtCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    MTETShirt * tshirt = [self.tshirtExplorer tshirtAtIndex:indexPath.row];
    cell.textLabel.text = tshirt.name;
    
    NSString * imagePath = [MTETShirt pathToLocalImageWithIdentifier:tshirt.identifier];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    if (image)
    {
        [cell.imageView setImage:image];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Sync

- (void)syncFinished:(id)sender
{
    MBProgressHUD * progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_SUCCESS]];
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.labelText = @"Sync Successful!";
    
    [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
    
    [self.tshirtExplorer updateData];
    [self.tableView reloadData];
}

- (void)syncFailed:(id)sender
{
    MBProgressHUD * progressHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_ERROR]];
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.labelText = @"Sync Failed";
    
    [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
}

@end
