//
//  MTEMyTeeAPIClient.m
//  mytee
//
//  Created by Vincent Tourraine on 1/19/13.
//  Copyright (c) 2013 Studio AMANgA. All rights reserved.
//

#import "MTEMyTeeAPIClient.h"

static NSString * const kMTEMyTeeAPIBaseURLString = @"http://www.studioamanga.com/mytee/api/";
static NSString * const kMTEMyTeeAPIAuthenticationPath = @"user/me";

@implementation MTEMyTeeAPIClient

+ (MTEMyTeeAPIClient *)sharedClient
{
    static MTEMyTeeAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kMTEMyTeeAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (void)sendAuthenticationRequestWithUsername:(NSString *)username password:(NSString *)password success:(void(^)())success failure:(void(^)())failure
{
    [self getPath:kMTEMyTeeAPIAuthenticationPath parameters:@{@"login" : username, @"password" : password}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (success)
                  success();
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (failure)
                  failure();
          }];
}

@end
