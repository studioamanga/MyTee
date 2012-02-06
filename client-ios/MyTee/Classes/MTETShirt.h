//
//  MTETShirt.h
//  mytee
//
//  Created by Vincent Tourraine on 1/31/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#define MTE_MINIATURE_IMAGE_SIZE 44

@class MTEStore;

@interface MTETShirt : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * condition;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * image_url;

@property (nonatomic, retain) MTEStore * store;
@property (nonatomic, retain) NSSet * wears;
@property (nonatomic, retain) NSSet * washs;

+ (NSString*)pathToLocalImageWithIdentifier:(NSString*)identifier;
+ (NSString*)pathToMiniatureLocalImageWithIdentifier:(NSString*)identifier;

@end
