//
//  MTEAuthenticationManager.m
//  mytee
//
//  Created by Terenn on 1/20/13.
//  Copyright (c) 2013 Studio AMANgA. All rights reserved.
//

#import "MTEAuthenticationManager.h"
#import <KeychainItemWrapper.h>

#define MTE_KEYCHAIN_IDENTIFIER @"MyTee credentials"

@interface MTEAuthenticationManager ()

+ (KeychainItemWrapper*)keychainWrapper;
+ (NSString*)valueFromKeychainWithKey:(NSString*)key;

@end


@implementation MTEAuthenticationManager

+ (KeychainItemWrapper*)keychainWrapper
{
    return [[KeychainItemWrapper alloc] initWithIdentifier:MTE_KEYCHAIN_IDENTIFIER accessGroup:nil];
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

+ (NSString*)passwordFromKeychain
{
    return [self valueFromKeychainWithKey:(__bridge NSString*)kSecValueData];
}

@end
