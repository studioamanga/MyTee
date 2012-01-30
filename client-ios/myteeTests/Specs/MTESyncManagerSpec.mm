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
    
    it(@"should build ", ^{
        
        NSURLRequest * request = [MTESyncManager requestForAuthenticatingWithEmail:@"studioamanga@gmail.com" password:@"secret"];
        
        NSString * expectedURL = @"http://www.studioamanga.com/mytee/api/store/all?login=studioamanga%40gmail.com&password=secret";
        request.URL.absoluteString should equal(expectedURL);
    }); 
});

SPEC_END