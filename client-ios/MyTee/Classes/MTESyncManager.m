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

#import "MTETShirt.h"

#define MTE_URL_API @"http://www.studioamanga.com/mytee/api/"
#define MTE_URL_API_TSHIRTS_ALL @"/tshirt/all"
#define MTE_URL_AUTHENTICATION @"http://www.studioamanga.com/mytee/api/store/all"

#define MTE_KEYCHAIN_IDENTIFIER @"MyTee credentials"
#define MTE_KEYCHAIN_ACCESS_GROUP @"77S3V3W24J.com.studioamanga.mytee"

@implementation MTESyncManager

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

+ (void)storeEmail:(NSString*)email password:(NSString*)password
{
    KeychainItemWrapper * keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:MTE_KEYCHAIN_IDENTIFIER accessGroup:MTE_KEYCHAIN_ACCESS_GROUP];
    
    [keychainWrapper setObject:email forKey:(__bridge NSString*)kSecAttrAccount];
    [keychainWrapper setObject:password forKey:(__bridge NSString*)kSecValueData];
}

+ (NSString*)valueFromKeychainWithKey:(NSString*)key
{
    KeychainItemWrapper * keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:MTE_KEYCHAIN_IDENTIFIER accessGroup:MTE_KEYCHAIN_ACCESS_GROUP];
    
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

#pragma mark - RestKit

- (void)setupSyncManager
{
    //RKLogConfigureByName("RestKit/*", RKLogLevelTrace);
    
    RKObjectManager * objectManager = [RKObjectManager objectManagerWithBaseURL:MTE_URL_API];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"mytee.sqlite"];
    
    [RKObjectManager setSharedManager:objectManager];
}

- (void)startSync
{
    RKManagedObjectMapping* tshirtMapping = [RKManagedObjectMapping mappingForClass:[MTETShirt class]];
    [tshirtMapping setPrimaryKeyAttribute:@"identifier"];
    [tshirtMapping mapAttributes:@"identifier", @"name", @"size", @"color", @"condition", @"location", @"rating", @"tags", @"note", @"image_url", nil];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:tshirtMapping forKeyPath:@""];
    
    NSString * email = [MTESyncManager emailFromKeychain];
    NSString * password = [MTESyncManager passwordFromKeychain];
    NSString * tshirtPath = [MTESyncManager pathForResource:MTE_URL_API_TSHIRTS_ALL withEmail:email password:password];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:tshirtPath delegate:self];
}

#pragma mark - Object loader

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects
{
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
                        }
                    }];
                }
            }
        }
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTE_NOTIFICATION_SYNC_FAILED object:nil];
}

@end
