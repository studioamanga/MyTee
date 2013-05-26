//
//  MTEWash.m
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEWash.h"
#import "MTETShirt.h"

@implementation MTEWash

@dynamic identifier;
@dynamic date;
@dynamic tshirt;

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [self initWithEntity:[NSEntityDescription entityForName:NSStringFromClass([MTEWash class]) inManagedObjectContext:context] insertIntoManagedObjectContext:nil];
    return self;
}

@end
