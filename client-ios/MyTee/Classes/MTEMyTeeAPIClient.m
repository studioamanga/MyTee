//
//  MTEMyTeeAPIClient.m
//  mytee
//
//  Created by Vincent Tourraine on 1/19/13.
//  Copyright (c) 2013 Studio AMANgA. All rights reserved.
//

#import "MTEMyTeeAPIClient.h"
#import "MTEAuthenticationManager.h"

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

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - Authentication

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


#pragma mark - AFIncrementalStore

- (NSURLRequest *)requestForFetchRequest:(NSFetchRequest *)fetchRequest
                             withContext:(NSManagedObjectContext *)context
{
    NSMutableURLRequest *mutableURLRequest = nil;
    if ([fetchRequest.entityName isEqualToString:@"MTETShirt"])
    {
        NSDictionary *parameters = @{@"login" : [MTEAuthenticationManager emailFromKeychain], @"password" : [MTEAuthenticationManager passwordFromKeychain]};
        mutableURLRequest = [self requestWithMethod:@"GET" path:@"tshirt/all" parameters:parameters];
    }
    
    return mutableURLRequest;
}

- (NSDictionary *)attributesForRepresentation:(NSDictionary *)representation
                                     ofEntity:(NSEntityDescription *)entity
                                 fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutablePropertyValues = [[super attributesForRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    if ([entity.name isEqualToString:@"MTETShirt"])
    {
    }
    
    return mutablePropertyValues;
}

- (NSDictionary *)representationsForRelationshipsFromRepresentation:(NSDictionary *)representation
                                                           ofEntity:(NSEntityDescription *)entity
                                                       fromResponse:(NSHTTPURLResponse *)response
{
    NSMutableDictionary *mutableRepresentations = [[super representationsForRelationshipsFromRepresentation:representation ofEntity:entity fromResponse:response] mutableCopy];
    
    if ([entity.name isEqualToString:@"MTETShirt"])
    {
        mutableRepresentations[@"wears"] = representation[@"wear"];
        mutableRepresentations[@"washs"] = representation[@"wash"];
    }
    
    return mutableRepresentations;
}

- (BOOL)shouldFetchRemoteAttributeValuesForObjectWithID:(NSManagedObjectID *)objectID
                                 inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

- (BOOL)shouldFetchRemoteValuesForRelationship:(NSRelationshipDescription *)relationship
                               forObjectWithID:(NSManagedObjectID *)objectID
                        inManagedObjectContext:(NSManagedObjectContext *)context
{
    return NO;
}

@end
