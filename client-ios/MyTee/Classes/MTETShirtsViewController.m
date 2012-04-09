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

#import "MTETShirtViewController.h"
#import "MTESettingsViewController.h"
#import "MTELoginViewController.h"

#import "AQGridView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MTETShirtsViewController

@synthesize syncManager;
@synthesize tshirtExplorer;
@synthesize detailViewController;
@synthesize settingsBarButtonItem;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController = (MTETShirtViewController*)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
    
    UIImage * woodTexture = [UIImage imageNamed:@"wood"];
    UIColor * woodColor = [UIColor colorWithPatternImage:woodTexture];
    self.gridView.backgroundColor = woodColor;
    
    self.gridView.leftContentInset = 3;
    self.gridView.rightContentInset = 3;
    self.gridView.gridHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    self.gridView.gridFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    
    self.syncManager = [MTESyncManager new];
    [self.syncManager setupSyncManager];
    
    self.tshirtExplorer = [MTETShirtExplorer new];
    NSManagedObjectContext * context = [[[RKObjectManager sharedManager] objectStore] managedObjectContext];
    [self.tshirtExplorer setupFetchedResultsControllerWithContext:context];
    [self.tshirtExplorer updateData];
    
    [self.gridView reloadData];
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(shouldSyncNow:) name:MTE_NOTIFICATION_SHOULD_SYNC_NOW object:nil];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncStarted:) name:MTE_NOTIFICATION_SYNC_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncFinished:) name:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncFailed:) name:MTE_NOTIFICATION_SYNC_FAILED object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.settingsBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    if ([self.syncManager isSyncing])
    {
        [self startSpinningAnimation];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSString * email = [MTESyncManager emailFromKeychain];
    if (!email)
    {
        [self performSegueWithIdentifier:@"MTELoginSegue" sender:nil];
    }
    else if (!self.syncManager.isSyncing)
    {
        [self.syncManager startSync];
    }
}

- (void)startSpinningAnimation
{
    CABasicAnimation * spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.fromValue = [NSNumber numberWithFloat:0];
    spinAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.duration = 0.5;
    spinAnimation.delegate = self;
    
    [self.settingsBarButtonItem.customView.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

- (IBAction)didPressSettingsBarButtonItem:(id)sender
{
    [self performSegueWithIdentifier:@"MTESettingsSegue" sender:nil];
    
    //[self.syncManager startSync];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (self.syncManager.isSyncing)
    {
        [self startSpinningAnimation];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MTELoginSegue"])
    {
        UINavigationController * navigationController = segue.destinationViewController;
        MTELoginViewController * viewController = (MTELoginViewController*)navigationController.topViewController;
        viewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"MTESettingsSegue"])
    {
        UINavigationController * navigationController = segue.destinationViewController;
        MTESettingsViewController * viewController = (MTESettingsViewController*)navigationController.topViewController;
        viewController.delegate = self;
        viewController.syncManager = self.syncManager;
    }
    else if ([[segue identifier] isEqualToString:@"MTETShirtSegue"])
    {
        MTETShirtViewController * viewController = segue.destinationViewController;
        
        NSUInteger index = [self.gridView indexOfSelectedItem];
        MTETShirt * tshirt = [self.tshirtExplorer tshirtAtIndex:index];
        //NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        //MTETShirt * tshirt = [self.tshirtExplorer tshirtAtIndex:indexPath.row];
        viewController.tshirt = tshirt;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return [self.tshirtExplorer numberOfTShirts];
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)gridView
{
    return CGSizeMake(78, 78);
}

- (AQGridViewCell*)gridView:(AQGridView*) aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString * PlainCellIdentifier = @"PlainCellIdentifier";
    
    AQGridViewCell * cell = [aGridView dequeueReusableCellWithIdentifier:PlainCellIdentifier];
    if (cell == nil)
    {
        cell = [[AQGridViewCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 150.0)
                                     reuseIdentifier:PlainCellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = AQGridViewCellSelectionStyleNone;
    }
    
    MTETShirt * tshirt = [self.tshirtExplorer tshirtAtIndex:index];
    
    NSString * imagePath = [MTETShirt pathToMiniatureLocalImageWithIdentifier:tshirt.identifier];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(3, 3, 78-2*3, 78-2*3);
    [cell.contentView addSubview:imageView];
    
    return cell;
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

    NSString * imagePath = [MTETShirt pathToMiniatureLocalImageWithIdentifier:tshirt.identifier];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    if (image)
    {
        [cell.imageView setImage:image];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        MTETShirt * tshirt = [self.tshirtExplorer tshirtAtIndex:index];
        self.detailViewController.tshirt = tshirt;
    }
    else
    {
        [self performSegueWithIdentifier:@"MTETShirtSegue" sender:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        MTETShirt * tshirt = [self.tshirtExplorer tshirtAtIndex:indexPath.row];
        self.detailViewController.tshirt = tshirt;
    }
}

#pragma mark - Login

- (void)loginViewControllerDidLoggedIn:(MTELoginViewController*)loginViewController
{
    if (!self.syncManager.isSyncing)
    {
        [self.syncManager startSync];
    }
}

#pragma mark - Sync

- (void)shouldSyncNow:(id)sender
{
    [self.syncManager startSync];
}

- (void)syncStarted:(id)sender
{
    [self startSpinningAnimation];
}

- (void)syncFinished:(id)sender
{
    /*
    MBProgressHUD * progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_SUCCESS]];
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.labelText = @"Sync Successful!";
    
    [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
    */
    
    [self.tshirtExplorer updateData];
    //[self.tableView reloadData];
    [self.gridView reloadData];
}

- (void)syncFailed:(id)sender
{
    MBProgressHUD * progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_ERROR]];
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.labelText = @"Sync Failed";
    
    [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
}

#pragma mark - Settings view controller delegate

- (void)settingsViewControllerShouldClose:(MTESettingsViewController*)settingsViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)settingsViewControllerShouldSyncNow:(MTESettingsViewController*)settingsViewController
{
    [self.syncManager startSync];
}

- (void)settingsViewControllerShouldLogOut:(MTESettingsViewController*)settingsViewController
{
    [self.detailViewController.navigationController popToRootViewControllerAnimated:NO];
    self.detailViewController.tshirt = nil;
    
    [self.syncManager resetAllData];
    
    [MTESyncManager resetKeychain];
    
    [self.tshirtExplorer updateData];
    //[self.tableView reloadData];
    [self.gridView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"MTELoginSegue" sender:nil];
    }];
}

@end
