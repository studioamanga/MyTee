//
//  MTEStore.h
//  mytee
//
//  Created by Vincent Tourraine on 2/3/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

@class MTETShirt;

@interface MTEStore : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@property (nonatomic, retain) NSSet *tshirts;

@end

@interface MTEStore (CoreDataGeneratedAccessors)

- (void)addTshirtsObject:(MTETShirt *)value;
- (void)removeTshirtsObject:(MTETShirt *)value;
- (void)addTshirts:(NSSet *)values;
- (void)removeTshirts:(NSSet *)values;

@end
