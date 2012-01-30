//
//  MTESyncManager.h
//  mytee
//
//  Created by Vincent Tourraine on 1/30/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTESyncManager : NSObject

+ (NSURLRequest*)requestForAuthenticatingWithEmail:(NSString*)email password:(NSString*)password;

+ (void)storeEmail:(NSString*)email password:(NSString*)password;
+ (NSString*)emailFromKeychain;
+ (NSString*)passwordFromKeychain;

@end
