//
//  MTEManagedObjectCache.m
//  mytee
//
//  Created by Vincent Tourraine on 2/5/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEManagedObjectCache.h"

#import "MTESyncManager.h"
#import "MTETShirt.h"

@implementation MTEManagedObjectCache

- (NSArray*)fetchRequestsForResourcePath:(NSString*)resourcePath
{
    NSString * pathToTShirts = [MTESyncManager pathForResource:MTE_URL_API_TSHIRTS_ALL 
                                                     withEmail:[MTESyncManager emailFromKeychain] 
                                                      password:[MTESyncManager passwordFromKeychain]];
    
	if ([resourcePath isEqualToString:pathToTShirts])
    {
		NSFetchRequest* request = [MTETShirt fetchRequest];
		NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES];
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		return [NSArray arrayWithObject:request];
	}
    
	return nil;
}

@end
