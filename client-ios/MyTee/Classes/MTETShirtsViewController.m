//
//  MTETShirtsViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTETShirtsViewController.h"

#import "MTETShirt.h"
#import "MTETShirtExplorer.h"
#import "MTEAuthenticationManager.h"

#import "MBProgressHUD.h"
#import "MTEConstView.h"

#import "MTETShirtViewController.h"
#import "MTESettingsViewController.h"
#import "MTELoginViewController.h"
#import "MTETShirtsFilterViewController.h"
#import "ECSlidingViewController.h"
#import "KSCustomPopoverBackgroundView.h"

#import <QuartzCore/QuartzCore.h>

@interface MTETShirtsViewController () <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *filterPopoverController;

@end

@implementation MTETShirtsViewController

#pragma mark - View lifecycle

- (void)setSyncManager:(MTESyncManager *)syncManager
{
    _syncManager = syncManager;
    
    self.tshirtExplorer = [MTETShirtExplorer new];
    [self.tshirtExplorer updateData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        self.detailViewController = (MTETShirtViewController*)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    UIImage *woodTexture;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        woodTexture = [UIImage imageNamed:(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? @"shelves-portrait" : @"shelves-landscape"];
    else
        woodTexture = [UIImage imageNamed:@"shelves"];
    UIColor *woodColor = [UIColor colorWithPatternImage:woodTexture];
    self.collectionView.backgroundColor = woodColor;
    
//    [[NSNotificationCenter defaultCenter] 
//     addObserver:self selector:@selector(shouldSyncNow:) name:MTE_NOTIFICATION_SHOULD_SYNC_NOW object:nil];
//    [[NSNotificationCenter defaultCenter] 
//     addObserver:self selector:@selector(syncStarted:) name:MTE_NOTIFICATION_SYNC_STARTED object:nil];
//    [[NSNotificationCenter defaultCenter] 
//     addObserver:self selector:@selector(syncFinished:) name:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
//    [[NSNotificationCenter defaultCenter] 
//     addObserver:self selector:@selector(syncFailed:) name:MTE_NOTIFICATION_SYNC_FAILED object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (![self.slidingViewController.underRightViewController isKindOfClass:[UIViewController class]])
        {
            UINavigationController *settingsNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTESettingsNavigationController"];
            MTESettingsViewController *settingsViewController = (MTESettingsViewController *)settingsNavigationController.topViewController;
            settingsViewController.syncManager = self.syncManager;
            settingsViewController.delegate = self;
            self.slidingViewController.underRightViewController  = settingsNavigationController;
        }
        
        if (![self.slidingViewController.underLeftViewController isKindOfClass:[UIViewController class]])
        {
            UINavigationController *filterNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTEFilterNavigationController"];
            ((MTETShirtsFilterViewController *)filterNavigationController.topViewController).delegate = self;
            self.slidingViewController.underLeftViewController  = filterNavigationController;
        }
    
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
        [self.slidingViewController setAnchorLeftRevealAmount:280];
        [self.slidingViewController setAnchorRightRevealAmount:280];
        
        self.navigationController.view.clipsToBounds = NO;
        self.navigationController.view.layer.shadowOpacity = 0.75;
        self.navigationController.view.layer.shadowRadius = 10;
        self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    
//    if ([self.syncManager isSyncing])
//        [self startSpinningAnimation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSString *email = [MTEAuthenticationManager emailFromKeychain];
    if (!email)
        [self performSegueWithIdentifier:@"MTELoginSegue" sender:nil];
}

- (void)startSpinningAnimation
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.fromValue = [NSNumber numberWithFloat:0];
    spinAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.duration = 0.8;
    spinAnimation.delegate = self;
    
    [self.settingsBarButtonItem.customView.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
}

- (IBAction)didPressSettingsBarButtonItem:(id)sender
{
    [self performSegueWithIdentifier:@"MTESettingsSegue" sender:nil];
}

- (IBAction)showFilterViewController:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (self.filterPopoverController)
        {
            [self.filterPopoverController dismissPopoverAnimated:YES];
            self.filterPopoverController = nil;
        }
        else
        {
            MTETShirtsFilterViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTETShirtsFilterViewController"];
            viewController.delegate = self;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            self.filterPopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
            self.filterPopoverController.popoverBackgroundViewClass = [KSCustomPopoverBackgroundView class];
            self.filterPopoverController.delegate = self;
            [self.filterPopoverController presentPopoverFromRect:CGRectMake(0, 0, 44, 44) inView:self.navigationController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else
        [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)showSettingsViewController:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
//    if (self.syncManager.isSyncing)
//    {
//        [self startSpinningAnimation];
//    }
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
    else if([segue.identifier isEqualToString:@"MTEFilterSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        MTETShirtsFilterViewController *viewController = (MTETShirtsFilterViewController*)navigationController.topViewController;
        viewController.delegate = self;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIImage *woodTexture = [UIImage imageNamed:(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) ? @"shelves-portrait" : @"shelves-landscape"];
        UIColor *woodColor = [UIColor colorWithPatternImage:woodTexture];
        self.collectionView.backgroundColor = woodColor;
    }
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
    
    MTETShirt *tshirt = [self.tshirtExplorer tshirtAtIndex:indexPath.row];
    NSString *imagePath = [MTETShirt pathToMiniatureLocalImageWithIdentifier:tshirt.identifier];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    UIImageView *tshirtImageView = nil;
    if ([[cell.contentView.subviews lastObject] isMemberOfClass:[UIImageView class]])
        tshirtImageView = [cell.contentView.subviews lastObject];
    
    if (!tshirtImageView)
    {
        tshirtImageView = [[UIImageView alloc] initWithImage:image];
        tshirtImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            CGFloat tshirtSize = cell.bounds.size.width - 2*20;
            tshirtImageView.frame = CGRectMake(10, (cell.bounds.size.height - tshirtSize)/2 + 8, tshirtSize, tshirtSize);
        }
        else
        {
            CGFloat tshirtSize = cell.bounds.size.width - 2*8;
            tshirtImageView.frame = CGRectMake(8, (cell.bounds.size.height - tshirtSize)/2 + 8, tshirtSize, tshirtSize);
        }
        
        tshirtImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        tshirtImageView.layer.borderWidth = 1;
        tshirtImageView.layer.cornerRadius = 4;
        tshirtImageView.clipsToBounds = YES;
        
        [cell.contentView addSubview:tshirtImageView];
    }
    else
    {
        tshirtImageView.image = image;
    }
    
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
//    if (!self.syncManager.isSyncing)
//    {
//        [self.syncManager startSync];
//    }
}

#pragma mark - Sync

- (void)shouldSyncNow:(id)sender
{
//    [self.syncManager startSync];
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
//    [self.syncManager startSync];
}

- (void)settingsViewControllerShouldLogOut:(MTESettingsViewController *)settingsViewController
{
//    [self.syncManager resetAllData];
    
    [MTEAuthenticationManager resetKeychain];
    
    [self.tshirtExplorer updateData];
    [self.collectionView reloadData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.detailViewController.navigationController popToRootViewControllerAnimated:NO];
        self.detailViewController.tshirt = nil;
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:@"MTELoginSegue" sender:nil];
        }];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.slidingViewController resetTopViewWithAnimations:nil onComplete:^{
            [self performSegueWithIdentifier:@"MTELoginSegue" sender:nil];
        }];
    }
}

#pragma mark - Filter view delegate

- (void)tshirtsFilterViewControllerDidChangeFilter:(MTETShirtsFilterViewController *)filterController
{
    [self.tshirtExplorer updateData];
    [self.collectionView reloadData];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.filterPopoverController dismissPopoverAnimated:YES];
        self.filterPopoverController = nil;
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - Popover controller

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.filterPopoverController = nil;
}

@end
