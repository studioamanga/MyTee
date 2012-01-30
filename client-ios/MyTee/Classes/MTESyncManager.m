//
//  MTESyncManager.m
//  mytee
//
//  Created by Vincent Tourraine on 1/30/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTESyncManager.h"

#import "NSString+NSStringURL.h"

#define MTE_URL_AUTHENTICATION @"http://www.studioamanga.com/mytee/api/store/all"

@implementation MTESyncManager

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

@end
