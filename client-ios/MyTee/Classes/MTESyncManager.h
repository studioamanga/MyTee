//
//  MTESyncManager.h
//  mytee
//
//  Created by Vincent Tourraine on 1/30/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "RestKit.h"

#define MTE_NOTIFICATION_SYNC_FINISHED @"MTENotifSyncFinished"
#define MTE_NOTIFICATION_SYNC_FAILED @"MTENotifSyncFailed"

@interface MTESyncManager : NSObject <RKObjectLoaderDelegate>

+ (NSString*)pathForResource:(NSString*)resourcePath withEmail:(NSString*)email password:(NSString*)password;
+ (NSURLRequest*)requestForAuthenticatingWithEmail:(NSString*)email password:(NSString*)password;

+ (void)storeEmail:(NSString*)email password:(NSString*)password;
+ (NSString*)emailFromKeychain;
+ (NSString*)passwordFromKeychain;

- (void)setupSyncManager;

- (void)startSync;

@end
