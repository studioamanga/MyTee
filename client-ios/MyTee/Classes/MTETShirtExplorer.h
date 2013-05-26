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
@protocol MTETShirtExplorerDelegate;

@interface MTETShirtExplorer : NSObject

@property (weak, nonatomic) id <MTETShirtExplorerDelegate> delegate;

- (void)setupFetchedResultsControllerWithContext:(NSManagedObjectContext *)objectContext;

- (NSUInteger)numberOfTShirts;
- (NSArray *)allTShirt;
- (MTETShirt *)tshirtAtIndex:(NSUInteger)index;

@end


@protocol MTETShirtExplorerDelegate <NSObject>

- (void)tshirtExplorerDidUpdateData:(MTETShirtExplorer *)tshirtExplorer;

@end