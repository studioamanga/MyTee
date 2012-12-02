//
//  MTEAppDelegate.m
//  mytee
//
//  Created by Vincent Tourraine on 1/28/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEAppDelegate.h"

#import "MTETodayTShirtViewController.h"
#import "MTETShirtsViewController.h"
#import "MTESettingsViewController.h"
#import "MTESyncManager.h"
#import "ECSlidingViewController.h"

@interface MTEAppDelegate ()

@property (nonatomic, strong) MTESyncManager * syncManager;
@end

@implementation MTEAppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"linen-nav-bar"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"linen-nav-bar-landscape"] forBarMetrics:UIBarMetricsLandscapePhone];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor], UITextAttributeTextShadowColor : [UIColor blackColor]}];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor darkGrayColor]];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor grayColor]];
    
    self.syncManager = [MTESyncManager new];
    
    [self.syncManager setupSyncManager];
    [self.syncManager startSync];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        MTETShirtsViewController * tshirtsViewController = (MTETShirtsViewController*)navController.topViewController;
        
        tshirtsViewController.syncManager = self.syncManager;
    }
    else 
    {
        ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.window.rootViewController;
        UINavigationController *tshirtsNavController = (UINavigationController *)[slidingViewController.storyboard instantiateViewControllerWithIdentifier:@"MTETShirtsNavigationController"];
        MTETShirtsViewController * tshirtsViewController = (MTETShirtsViewController *)tshirtsNavController.topViewController;
        slidingViewController.topViewController = tshirtsNavController;
        
//        UITabBarController * tabBarController = (UITabBarController*)self.window.rootViewController;
//        UINavigationController * navController0 = [tabBarController.viewControllers objectAtIndex:0];
//        MTETodayTShirtViewController * todayViewController = (MTETodayTShirtViewController*)navController0.topViewController;
//        UINavigationController * navController1 = [tabBarController.viewControllers objectAtIndex:1];
//        MTETShirtsViewController * tshirtsViewController = (MTETShirtsViewController*)navController1.topViewController;
//        UINavigationController * navController2 = [tabBarController.viewControllers objectAtIndex:2];
//        MTESettingsViewController * settingsViewController = (MTESettingsViewController*)navController2.topViewController;
        
//        UILocalNotification * localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//        if (localNotif)
//            tabBarController.selectedIndex = [tabBarController.viewControllers indexOfObject:navController1];
        
        tshirtsViewController.syncManager = self.syncManager;
//        settingsViewController.syncManager = syncManager;
        
//        todayViewController.managedObjectContext = self.managedObjectContext;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.syncManager startSync];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#ifdef DEBUG
            abort();
#endif
        } 
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
        return __managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
        return __managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"mytee" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
        return __persistentStoreCoordinator;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"mytee.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{ NSMigratePersistentStoresAutomaticallyOption : @(YES), NSInferMappingModelAutomaticallyOption : @(YES) } error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#ifdef DEBUG
        abort();
#endif
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
