//
//  MTETShirtExplorer.h
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTETShirt;

@interface MTETShirtExplorer : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController * fetchedResultsController;

- (void)setupFetchedResultsControllerWithContext:(NSManagedObjectContext*)objectContext;

- (BOOL)updateData;

- (NSUInteger)numberOfTShirts;
- (NSArray*)allTShirt;
- (MTETShirt*)tshirtAtIndex:(NSUInteger)index;

@end
