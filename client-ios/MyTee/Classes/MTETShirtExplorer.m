//
//  MTETShirtExplorer.m
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTETShirtExplorer.h"

#import "MTETShirt.h"
#import "MTEWear.h"

NSString *const kMTETShirtsFilterType = @"kMTETShirtsFilterType";
NSString *const kMTETShirtsFilterParameter = @"kMTETShirtsFilterParameter";

@interface MTETShirtExplorer () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSArray *fetchedTShirts;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)updateData;

@end


@implementation MTETShirtExplorer

- (void)setupFetchedResultsControllerWithContext:(NSManagedObjectContext *)objectContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([MTETShirt class])
                                              inManagedObjectContext:objectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"color" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:objectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    BOOL result = [self.fetchedResultsController performFetch:&error];
    if(!result)
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
}

- (void)updateData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger filterType = [userDefaults integerForKey:kMTETShirtsFilterType];
    
    if (filterType == MTETShirtsFilterWash)
    {
        self.fetchedTShirts = [self.fetchedResultsController.fetchedObjects sortedArrayWithOptions:kNilOptions usingComparator:^NSComparisonResult(MTETShirt *tshirt1, MTETShirt *tshirt2) {
            return [@([tshirt1 numberOfWearsSinceLastWash]) compare:@([tshirt2 numberOfWearsSinceLastWash])];
        }];
    }
    else if (filterType == MTETShirtsFilterWear)
    {
        self.fetchedTShirts = [self.fetchedResultsController.fetchedObjects sortedArrayWithOptions:kNilOptions usingComparator:^NSComparisonResult(MTETShirt *tshirt1, MTETShirt *tshirt2) {
            NSDate *tshirt1MostRecentWearDate = tshirt1.mostRecentWear.date;
            if (!tshirt1MostRecentWearDate)
                tshirt1MostRecentWearDate = [NSDate dateWithTimeIntervalSince1970:0];
            NSDate *tshirt2MostRecentWearDate = tshirt2.mostRecentWear.date;
            if (!tshirt2MostRecentWearDate)
                tshirt2MostRecentWearDate = [NSDate dateWithTimeIntervalSince1970:0];
            return [tshirt1MostRecentWearDate compare:tshirt2MostRecentWearDate];
        }];
    }
    else
        self.fetchedTShirts = self.fetchedResultsController.fetchedObjects;
    
    return;
}

- (NSUInteger)numberOfTShirts
{
    return [self.fetchedTShirts count];
}

- (NSArray *)allTShirt
{
    return self.fetchedTShirts;
}

- (MTETShirt *)tshirtAtIndex:(NSUInteger)index
{
    if(index >= self.numberOfTShirts)
        return nil;
    
    return [self.fetchedTShirts objectAtIndex:index];
}

#pragma mark - Fetch results controller

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self updateData];
    [self.delegate tshirtExplorerDidUpdateData:self];
}

@end
