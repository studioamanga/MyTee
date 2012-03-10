//
//  MTESyncManager.h
//  mytee
//
//  Created by Vincent Tourraine on 1/30/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "RestKit/RestKit.h"

#define MTE_URL_API_TSHIRTS_ALL @"/tshirt/all"
#define MTE_URL_API_TSHIRT_WEAR @"/tshirt/%@/wear"
#define MTE_URL_API_TSHIRT_WASH @"/tshirt/%@/wash"
#define MTE_URL_API_STORES_ALL @"/store/all"

#define MTE_NOTIFICATION_SYNC_STARTED @"MTENotifSyncStarted"
#define MTE_NOTIFICATION_SHOULD_SYNC_NOW @"MTENotifShouldSyncNow"
#define MTE_NOTIFICATION_SYNC_FINISHED @"MTENotifSyncFinished"
#define MTE_NOTIFICATION_SYNC_FAILED @"MTENotifSyncFailed"

@interface MTESyncManager : NSObject <RKObjectLoaderDelegate>

@property (nonatomic) BOOL isSyncing;

+ (NSString*)pathForResource:(NSString*)resourcePath withEmail:(NSString*)email password:(NSString*)password;

+ (NSURLRequest*)requestForAuthenticatingWithEmail:(NSString*)email password:(NSString*)password;
+ (BOOL)authenticationResponseIsSuccessful:(NSHTTPURLResponse*)response;

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
