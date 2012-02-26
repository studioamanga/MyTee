//
//  MTESyncManagerSpec.mm
//  myteeTests
//
//  Created by Vincent Tourraine on 31/01/12.
//  Copyright (c) 2011 Shazino. All rights reserved.
//

#import "SpecHelper.h"

#import "MTESyncManager.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(MTESyncManagerSpec)

describe(@"Sync Manager", ^{
    
    describe(@"authentication", ^{

        it(@"should have the right request", ^{
        
            NSURLRequest * request = [MTESyncManager requestForAuthenticatingWithEmail:@"studioamanga@gmail.com" password:@"secret"];
        
            NSString * expectedURL = @"http://www.studioamanga.com/mytee/api/user/me?login=studioamanga%40gmail.com&password=secret";
            request.URL.absoluteString should equal(expectedURL);
        });
        
        it(@"should handle API error", ^{
            
            NSHTTPURLResponse * response = nil;
            
            response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:nil];
            [MTESyncManager authenticationResponseIsSuccessful:response] should be_truthy;
            [response release];
            
            response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:304 HTTPVersion:nil headerFields:nil];
            [MTESyncManager authenticationResponseIsSuccessful:response] should_not be_truthy;
            [response release];
        });
    });
});

SPEC_END