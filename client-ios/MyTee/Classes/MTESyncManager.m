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

#import "RestKit.h"

#define MTE_URL_API @"http://www.studioamanga.com/mytee/api/"
#define MTE_URL_AUTHENTICATION @"http://www.studioamanga.com/mytee/api/store/all"

#define MTE_KEYCHAIN_IDENTIFIER @"MyTee credentials"
#define MTE_KEYCHAIN_ACCESS_GROUP @"77S3V3W24J.com.studioamanga.mytee"

@implementation MTESyncManager

#pragma mark - Keychain

+ (NSURLRequest*)requestForAuthenticatingWithEmail:(NSString*)email password:(NSString*)password
{
    NSString * urlString = [NSString stringWithFormat:@"%@?login=%@&password=%@",
                            MTE_URL_AUTHENTICATION,
                            [email URLEncode],
                            [password URLEncode]];
    
    NSURL * url = [NSURL URLWithString:urlString];
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

+ (void)setupSyncManager
{
    // RKLogConfigureByName("RestKit/*", RKLogLevelTrace);
    
    RKObjectManager * objectManager = [RKObjectManager objectManagerWithBaseURL:MTE_URL_API];
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"mytee.sqlite"];
    
    [RKObjectManager setSharedManager:objectManager];
}

@end
