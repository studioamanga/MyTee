//
//  MTEWear.m
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEWear.h"
#import "MTETShirt.h"

@implementation MTEWear

@dynamic identifier;
@dynamic date;
@dynamic tshirt;

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [self initWithEntity:[NSEntityDescription entityForName:NSStringFromClass([MTEWear class]) inManagedObjectContext:context] insertIntoManagedObjectContext:nil];
    return self;
}

@end
