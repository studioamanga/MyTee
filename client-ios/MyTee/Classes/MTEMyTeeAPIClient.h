//
//  MTEMyTeeAPIClient.h
//  mytee
//
//  Created by Vincent Tourraine on 1/19/13.
//  Copyright (c) 2013 Studio AMANgA. All rights reserved.
//

#import "AFRESTClient.h"
#import "AFIncrementalStore.h"

@interface MTEMyTeeAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (MTEMyTeeAPIClient *)sharedClient;

- (void)sendAuthenticationRequestWithUsername:(NSString *)username password:(NSString *)password success:(void(^)())success failure:(void(^)())failure;

@end
