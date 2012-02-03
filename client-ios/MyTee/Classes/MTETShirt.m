//
//  MTETShirt.m
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTETShirt.h"

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

@end
