//
//  MTEWash.h
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTETShirt;

@interface MTEWash : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) MTETShirt *tshirt;

@end
