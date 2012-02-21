//
//  MTESyncManager.h
//  mytee
//
//  Created by Vincent Tourraine on 1/30/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "RestKit.h"

#define MTE_URL_API_TSHIRTS_ALL @"/tshirt/all"
#define MTE_URL_API_STORES_ALL @"/store/all"

#define MTE_NOTIFICATION_SYNC_FINISHED @"MTENotifSyncFinished"
#define MTE_NOTIFICATION_SYNC_FAILED @"MTENotifSyncFailed"

@interface MTESyncManager : NSObject <RKObjectLoaderDelegate>

@property (nonatomic) BOOL isSyncing;

+ (NSString*)pathForResource:(NSString*)resourcePath withEmail:(NSString*)email password:(NSString*)password;
+ (NSURLRequest*)requestForAuthenticatingWithEmail:(NSString*)email password:(NSString*)password;

+ (void)resetKeychain;
+ (void)storeEmail:(NSString*)email password:(NSString*)password;
+ (NSString*)emailFromKeychain;
+ (NSString*)passwordFromKeychain;

+ (NSDate*)lastSyncDate;
+ (void)setLastSyncDateNow;

- (void)resetAllData;
- (void)setupSyncManager;

- (void)startSync;

@end
