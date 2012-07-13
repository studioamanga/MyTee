//
//  MTETShirtsViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
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

#import <QuartzCore/QuartzCore.h>

@implementation MTETShirtsViewController

#pragma mark - View lifecycle

- (void)setSyncManager:(MTESyncManager *)syncManager
{
    _syncManager = syncManager;
    
    self.tshirtExplorer = [MTETShirtExplorer new];
    NSManagedObjectContext *context = [[[RKObjectManager sharedManager] objectStore] managedObjectContext];
    [self.tshirtExplorer setupFetchedResultsControllerWithContext:context];
    [self.tshirtExplorer updateData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        self.detailViewController = (MTETShirtViewController*)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    UIImage *woodTexture = [UIImage imageNamed:@"wood"];
    UIColor *woodColor = [UIColor colorWithPatternImage:woodTexture];
    self.collectionView.backgroundColor = woodColor;
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(shouldSyncNow:) name:MTE_NOTIFICATION_SHOULD_SYNC_NOW object:nil];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncStarted:) name:MTE_NOTIFICATION_SYNC_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncFinished:) name:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] 
     addObserver:self selector:@selector(syncFailed:) name:MTE_NOTIFICATION_SYNC_FAILED object:nil];
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

    NSString *email = [MTESyncManager emailFromKeychain];
    if (!email)
        [self performSegueWithIdentifier:@"MTELoginSegue" sender:nil];
}

- (void)startSpinningAnimation
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
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
        UINavigationController *navigationController = segue.destinationViewController;
        MTELoginViewController *viewController = (MTELoginViewController*)navigationController.topViewController;
        viewController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"MTESettingsSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        MTESettingsViewController *viewController = (MTESettingsViewController*)navigationController.topViewController;
        viewController.delegate = self;
        viewController.syncManager = self.syncManager;
    }
    else if ([[segue identifier] isEqualToString:@"MTETShirtSegue"])
    {
        MTETShirtViewController *viewController = nil;
        if ([segue.destinationViewController isMemberOfClass:[MTETShirtViewController class]])
             viewController = segue.destinationViewController;
        else if ([segue.destinationViewController isMemberOfClass:[UINavigationController class]])
        {
            UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
            viewController = (MTETShirtViewController *)navigationController.topViewController;
        }
        
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        MTETShirt *tshirt = [self.tshirtExplorer tshirtAtIndex:indexPath.row];
        viewController.tshirt = tshirt;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Collection view data source

- (int)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tshirtExplorer numberOfTShirts];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MTETShirtCellID" forIndexPath:indexPath];
    
    for (UIView *subview in cell.contentView.subviews)
        [subview removeFromSuperview];
    
    MTETShirt *tshirt = [self.tshirtExplorer tshirtAtIndex:indexPath.row];
    NSString *imagePath = [MTETShirt pathToLocalImageWithIdentifier:tshirt.identifier];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectInset(cell.bounds, 5, 5);
    
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [self.detailViewController.navigationController popToRootViewControllerAnimated:YES];
        
        MTETShirt *tshirt = [self.tshirtExplorer tshirtAtIndex:indexPath.row];
        self.detailViewController.tshirt = tshirt;
    }
}

#pragma mark - Login

- (void)loginViewControllerDidLoggedIn:(MTELoginViewController *)loginViewController
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
    [self.tshirtExplorer updateData];
    [self.collectionView reloadData];
}

- (void)syncFailed:(id)sender
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MTE_HUD_IMAGE_ERROR]];
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.labelText = @"Sync Failed";
    
    [progressHUD hide:YES afterDelay:MTE_HUD_HIDE_DELAY];
}

#pragma mark - Settings view controller delegate

- (void)settingsViewControllerShouldClose:(MTESettingsViewController *)settingsViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)settingsViewControllerShouldSyncNow:(MTESettingsViewController *)settingsViewController
{
    [self.syncManager startSync];
}

- (void)settingsViewControllerShouldLogOut:(MTESettingsViewController *)settingsViewController
{
    [self.detailViewController.navigationController popToRootViewControllerAnimated:NO];
    self.detailViewController.tshirt = nil;
    
    [self.syncManager resetAllData];
    
    [MTESyncManager resetKeychain];
    
    [self.tshirtExplorer updateData];
    [self.collectionView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"MTELoginSegue" sender:nil];
    }];
}

@end
