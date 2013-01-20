//
//  MTEAppDelegate.m
//  mytee
//
//  Created by Vincent Tourraine on 1/28/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEAppDelegate.h"

#import "MTEMyTeeIncrementalStore.h"
#import "MTETodayTShirtViewController.h"
#import "MTETShirtsViewController.h"
#import "MTESettingsViewController.h"
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
    [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[UIPopoverController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsLandscapePhone];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor darkGrayColor]];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"selection-tab"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor grayColor]];
    
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
        
        tshirtsViewController.syncManager = self.syncManager;
    }
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"mytee" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    AFIncrementalStore *incrementalStore = (AFIncrementalStore *)[__persistentStoreCoordinator addPersistentStoreWithType:[MTEMyTeeIncrementalStore type] configuration:nil URL:nil options:nil error:nil];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyTee.sqlite"];
    
    NSDictionary *options = @{
    NSInferMappingModelAutomaticallyOption : @(YES),
NSMigratePersistentStoresAutomaticallyOption: @(YES)
    };
    
    NSError *error = nil;
    if (![incrementalStore.backingPersistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"SQLite URL: %@", storeURL);
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
