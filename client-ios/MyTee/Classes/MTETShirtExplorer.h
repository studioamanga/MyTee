//
//  MTETShirtExplorer.h
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

FOUNDATION_EXPORT NSString *const kMTETShirtsFilterType;
FOUNDATION_EXPORT NSString *const kMTETShirtsFilterParameter;

typedef enum
{
    MTETShirtsFilterAll = 0,
    MTETShirtsFilterWear,
    MTETShirtsFilterWash
} MTETShirtsFilterType;


@class MTETShirt;

@interface MTETShirtExplorer : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController * fetchedResultsController;

- (void)setupFetchedResultsControllerWithContext:(NSManagedObjectContext*)objectContext;

- (BOOL)updateData;

- (NSUInteger)numberOfTShirts;
- (NSArray*)allTShirt;
- (MTETShirt*)tshirtAtIndex:(NSUInteger)index;

@end
