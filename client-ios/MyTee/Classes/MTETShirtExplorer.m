//
//  MTETShirtExplorer.m
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTETShirtExplorer.h"

#import "MTETShirt.h"

NSString *const kMTETShirtsFilterType = @"kMTETShirtsFilterType";
NSString *const kMTETShirtsFilterParameter = @"kMTETShirtsFilterParameter";

@interface MTETShirtExplorer ()

@property (nonatomic, strong) NSArray *fetchedTShirts;

@end


@implementation MTETShirtExplorer

- (void)setupFetchedResultsControllerWithContext:(NSManagedObjectContext*)objectContext
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([MTETShirt class]) 
                                               inManagedObjectContext:objectContext];
    [fetchRequest setEntity:entity];
    
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"color" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:objectContext
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
}

- (BOOL)updateData
{
    NSError * error = nil;
    BOOL result = [self.fetchedResultsController performFetch:&error];
    if(!result)
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger filterType = [userDefaults integerForKey:kMTETShirtsFilterType];
    NSUInteger filterParameter = [userDefaults integerForKey:kMTETShirtsFilterParameter];
    if (filterType == MTETShirtsFilterWash)
        self.fetchedTShirts = [self.fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(MTETShirt *evaluatedObject, NSDictionary *bindings) {
            NSArray *orderedWashs = evaluatedObject.washsSortedByDate;
            NSDate *latestWash = ([orderedWashs count] > 0) ? [[orderedWashs objectAtIndex:0] date] : [NSDate dateWithTimeIntervalSince1970:0];
            NSSet *newerWears = [evaluatedObject.wears filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"date > %@", latestWash]];
            return [newerWears count] >= filterParameter;
        }]];
    else
        self.fetchedTShirts = self.fetchedResultsController.fetchedObjects;
    
    return result;
}

- (NSUInteger)numberOfTShirts
{
    return [self.fetchedTShirts count];
}

- (NSArray*)allTShirt
{
    return self.fetchedTShirts;
}

- (MTETShirt*)tshirtAtIndex:(NSUInteger)index
{
    if(index >= self.numberOfTShirts)
        return nil;
    
    return [self.fetchedTShirts objectAtIndex:index];
}

@end
