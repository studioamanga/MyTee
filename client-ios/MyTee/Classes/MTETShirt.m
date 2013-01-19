//
//  MTETShirt.m
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTETShirt.h"

#import "MTEWear.h"
#import "MTEWash.h"

@implementation MTETShirt

@dynamic identifier;
@dynamic name;
@dynamic size;
@dynamic color;
@dynamic condition;
@dynamic location;
@dynamic rating;
@dynamic tags;
@dynamic note;
@dynamic image_url;

@dynamic store;
@dynamic wears;
@dynamic washs;

#pragma mark - Image paths

+ (NSString *)pathToLocalImageDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)pathToLocalImageWithIdentifier:(NSString*)identifier
{
    return [[self pathToLocalImageDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"MTE_%@.jpg", identifier]];
}

+ (NSString *)pathToMiniatureLocalImageWithIdentifier:(NSString*)identifier
{
    return [[self pathToLocalImageDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"MTE_%@_mini.jpg", identifier]];
}

#pragma mark - Wear/Wash

- (NSArray *)wearsSortedByDate
{
    return [self.wears sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
}

- (MTEWear *)mostRecentWear
{
    NSArray * wears = [self wearsSortedByDate];
    return ([wears count] == 0) ? nil : wears[0];
}

- (NSArray *)washsSortedByDate
{
    return [self.washs sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
}

- (MTEWash *)mostRecentWash
{
    NSArray * washs = [self washsSortedByDate];
    return ([washs count] == 0) ? nil : washs[0];
}

- (NSUInteger)numberOfWearsSinceLastWash
{
    NSDate *mostRecentWashDate = [self mostRecentWash].date;
    return [[[NSSet setWithArray:[self wearsSortedByDate]] objectsPassingTest:^BOOL(MTEWear *wear, BOOL *stop) {
        return [wear.date compare:mostRecentWashDate];
    }] count];
}

@end
