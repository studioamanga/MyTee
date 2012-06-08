//
//  MTETShirtExplorer.m
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTETShirtExplorer.h"

#import "MTETShirt.h"

@implementation MTETShirtExplorer

@synthesize fetchedResultsController;

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
    
    [self.fetchedResultsController setDelegate:self];
}

- (BOOL)updateData
{
    NSError * error = nil;
    BOOL result = [self.fetchedResultsController performFetch:&error];
    if(!result)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return result;
}

- (NSUInteger)numberOfTShirts
{
    return [self.fetchedResultsController fetchedObjects].count;
}

- (NSArray*)allTShirt
{
    return [self.fetchedResultsController fetchedObjects];
}

- (MTETShirt*)tshirtAtIndex:(NSUInteger)index
{
    if(index >= self.numberOfTShirts)
        return nil;
    
    return [[self.fetchedResultsController fetchedObjects] objectAtIndex:index];
}

@end
