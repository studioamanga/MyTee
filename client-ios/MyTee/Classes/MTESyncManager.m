//
//  MTESyncManager.m
//  mytee
//
//  Created by Vincent Tourraine on 1/30/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTESyncManager.h"

#import "KeychainItemWrapper.h"
#import "NSString+NSStringURL.h"
#import "MTEManagedObjectCache.h"

#import "MTETShirt.h"
#import "MTEWash.h"
#import "MTEWear.h"
#import "MTEStore.h"

#define MTE_URL_API @"http://www.studioamanga.com/mytee/api/"
#define MTE_URL_AUTHENTICATION @"http://www.studioamanga.com/mytee/api/store/all"

#define MTE_KEYCHAIN_IDENTIFIER @"MyTee credentials"
#define MTE_KEYCHAIN_ACCESS_GROUP @"77S3V3W24J.com.studioamanga.mytee"

#define MTE_USER_DEFAULTS_LAST_SYNC_DATE @"kMTEUserDefaultsLastSyncDate"

@implementation MTESyncManager

@synthesize isSyncing;

#pragma mark - Keychain

+ (NSString*)pathForResource:(NSString*)resourcePath withEmail:(NSString*)email password:(NSString*)password
{
    NSString * urlString = [NSString stringWithFormat:@"%@?login=%@&password=%@",
                            resourcePath,
                            [email URLEncode],
                            [password URLEncode]];
    
    return urlString;
}

+ (NSURLRequest*)requestForAuthenticatingWithEmail:(NSString*)email password:(NSString*)password
{
    NSURL * url = [NSURL URLWithString:[self pathForResource:MTE_URL_AUTHENTICATION withEmail:email password:password]];
    NSMutableURLRequest * request = [NSURLRequest requestWithURL:url];
    
    return request;
}

#pragma mark - 

+ (KeychainItemWrapper*)keychainWrapper
{
    return [[KeychainItemWrapper alloc] initWithIdentifier:MTE_KEYCHAIN_IDENTIFIER accessGroup:MTE_KEYCHAIN_ACCESS_GROUP];
}

+ (void)resetKeychain
{
    KeychainItemWrapper * keychainWrapper = [self keychainWrapper];
    [keychainWrapper resetKeychainItem];
}

+ (void)storeEmail:(NSString*)email password:(NSString*)password
{
    KeychainItemWrapper * keychainWrapper = [self keychainWrapper];
    
    [keychainWrapper setObject:email forKey:(__bridge NSString*)kSecAttrAccount];
    [keychainWrapper setObject:password forKey:(__bridge NSString*)kSecValueData];
}

+ (NSString*)valueFromKeychainWithKey:(NSString*)key
{
    KeychainItemWrapper * keychainWrapper = [self keychainWrapper];
    
    NSString * keychainValue = [keychainWrapper objectForKey:key];
    if ([keychainValue isEqualToString:@""])
        return nil; 
    
    return keychainValue;
}

+ (NSString*)emailFromKeychain
{
    return [self valueFromKeychainWithKey:(__bridge NSString*)kSecAttrAccount];
}

+ (NSString*)passwordFromKeychain;
{
    return [self valueFromKeychainWithKey:(__bridge NSString*)kSecValueData];
}

#pragma mark - Sync date

+ (NSDate*)lastSyncDate
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:MTE_USER_DEFAULTS_LAST_SYNC_DATE];
}

+ (void)setLastSyncDateNow
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDate date] forKey:MTE_USER_DEFAULTS_LAST_SYNC_DATE];
    [userDefaults synchronize];
}

#pragma mark - RestKit

- (void)resetAllData
{
    NSError * error = nil;
    NSManagedObjectContext * context = [RKObjectManager sharedManager].objectStore.managedObjectContext;
    
    NSFetchRequest * tshirtsRequest = [MTETShirt fetchRequest];
    [tshirtsRequest setIncludesPropertyValues:NO];
    NSArray * tshirts = [context executeFetchRequest:tshirtsRequest error:&error];
    for (NSManagedObject * tshirt in tshirts)
        [context deleteObject:tshirt];
    [context save:&error];
    
    NSFetchRequest * storesRequest = [MTEStore fetchRequest];
    [storesRequest setIncludesPropertyValues:NO];
    NSArray * stores = [context executeFetchRequest:storesRequest error:&error];
    for (NSManagedObject * store in stores)
        [context deleteObject:store];
    [context save:&error];
    
    [[RKObjectManager sharedManager].client.requestCache invalidateAll];    
}

- (void)setupSyncManager
{
    //RKLogConfigureByName("RestKit/*", RKLogLevelTrace);
    self.isSyncing = NO;
    
    RKObjectManager * objectManager = [RKObjectManager objectManagerWithBaseURL:MTE_URL_API];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"mytee.sqlite"];
    
    NSTimeZone * utc = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd" inTimeZone:utc];
    
    objectManager.objectStore.managedObjectCache = [MTEManagedObjectCache new];
    
    [RKObjectManager setSharedManager:objectManager];
}

- (void)startSync
{
    self.isSyncing = YES;
    
    RKManagedObjectMapping * storeMapping = [RKManagedObjectMapping mappingForClass:[MTEStore class]];
    [storeMapping setPrimaryKeyAttribute:@"identifier"];
    [storeMapping mapAttributes:@"identifier", @"name", @"type", @"address", @"url", nil];
    
    RKManagedObjectMapping * wearMapping = [RKManagedObjectMapping mappingForClass:[MTEWear class]];
    [wearMapping setPrimaryKeyAttribute:@"identifier"];
    [wearMapping mapAttributes:@"identifier", @"date", nil];
    
    RKManagedObjectMapping * washMapping = [RKManagedObjectMapping mappingForClass:[MTEWash class]];
    [washMapping setPrimaryKeyAttribute:@"identifier"];
    [washMapping mapAttributes:@"identifier", @"date", nil];
    
    RKManagedObjectMapping * tshirtMapping = [RKManagedObjectMapping mappingForClass:[MTETShirt class]];
    [tshirtMapping setPrimaryKeyAttribute:@"identifier"];
    [tshirtMapping mapAttributes:@"identifier", @"name", @"size", @"color", @"condition", @"location", @"rating", @"tags", @"note", @"image_url", nil];
    [tshirtMapping mapKeyPath:@"wear" toRelationship:@"wears" withMapping:wearMapping];
    [tshirtMapping mapKeyPath:@"wash" toRelationship:@"washs" withMapping:washMapping];
    [tshirtMapping mapKeyPath:@"store" toRelationship:@"store" withMapping:storeMapping];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:tshirtMapping forKeyPath:@""];
    
    NSString * email = [MTESyncManager emailFromKeychain];
    NSString * password = [MTESyncManager passwordFromKeychain];
    NSString * tshirtPath = [MTESyncManager pathForResource:MTE_URL_API_TSHIRTS_ALL withEmail:email password:password];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:tshirtPath delegate:self];
}

#pragma mark - Object loader

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
    //NSLog(@">> didLoadObjects %d", [objects count]);
    self.isSyncing = NO;
    
    [MTESyncManager setLastSyncDateNow];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
     
    if ([[objectLoader resourcePath] rangeOfString:MTE_URL_API_TSHIRTS_ALL].location!=NSNotFound)
    {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSOperationQueue * queue = [NSOperationQueue new];
        
        for (MTETShirt * tshirt in objects) {
            if ([tshirt isMemberOfClass:[MTETShirt class]] && tshirt.image_url && ![tshirt.image_url isEqualToString:@""])
            {
                NSString * pathToImage = [MTETShirt pathToLocalImageWithIdentifier:tshirt.identifier];
                if (![fileManager fileExistsAtPath:pathToImage])
                {
                    NSURL * url = [NSURL URLWithString:tshirt.image_url];
                    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
                    
                    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse*response, NSData*data, NSError*error){
                        if(response)
                        {
                            [data writeToFile:pathToImage atomically:YES];
                        
                            UIImage * image = [UIImage imageWithData:data];
                            UIImage * miniImage = [MTESyncManager imageWithImage:image scaledToSize:CGSizeMake(MTE_MINIATURE_IMAGE_SIZE, MTE_MINIATURE_IMAGE_SIZE)];
                            NSString * pathMini = [MTETShirt pathToMiniatureLocalImageWithIdentifier:tshirt.identifier];
                            [UIImageJPEGRepresentation(miniImage, 0.8) writeToFile:pathMini atomically:YES];
                        }
                    }];
                }
            }
        }
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    self.isSyncing = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTE_NOTIFICATION_SYNC_FAILED object:nil];
}

@end
