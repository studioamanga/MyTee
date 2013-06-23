//
//  MTEMyTeeIncrementalStore.m
//  mytee
//
//  Created by Vincent Tourraine on 1/19/13.
//  Copyright (c) 2013 Studio AMANgA. All rights reserved.
//

#import "MTEMyTeeIncrementalStore.h"
#import "MTEMyTeeAPIClient.h"

@implementation MTEMyTeeIncrementalStore

+ (void)initialize
{
    [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:[self type]];
}

+ (NSString *)type
{
    return NSStringFromClass(self);
}

+ (NSManagedObjectModel *)model
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"mytee" withExtension:@"xcdatamodeld"]];
}

- (id<AFIncrementalStoreHTTPClient>)HTTPClient
{
    return [MTEMyTeeAPIClient sharedClient];
}

@end
