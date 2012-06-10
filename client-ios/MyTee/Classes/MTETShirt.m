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

+ (NSString*)pathToLocalImageWithIdentifier:(NSString*)identifier
{
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"MTE_%@.jpg", identifier]];
}

+ (NSString*)pathToMiniatureLocalImageWithIdentifier:(NSString*)identifier
{
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"MTE_%@_mini.jpg", identifier]];
}

#pragma mark - Wear/Wash

- (NSArray*)wearsSortedByDate
{
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [self.wears sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (MTEWear*)mostRecentWear
{
    NSArray * wears = [self wearsSortedByDate];
    return ([wears count] == 0) ? nil : [wears objectAtIndex:0];
}

- (NSArray*)washsSortedByDate
{
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [self.washs sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (MTEWash*)mostRecentWash
{
    NSArray * washs = [self washsSortedByDate];
    return ([washs count] == 0) ? nil : [washs objectAtIndex:0];
}

@end
