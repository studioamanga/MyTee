//
//  MTEStore.m
//  mytee
//
//  Created by Vincent Tourraine on 2/3/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEStore.h"
#import "MTETShirt.h"

NSString * const MTEUnknownStoreIdentifier = @"1";

@implementation MTEStore

@dynamic identifier;
@dynamic name;
@dynamic type;
@dynamic address;
@dynamic url;
@dynamic latitude;
@dynamic longitude;

@dynamic tshirts;

@end
