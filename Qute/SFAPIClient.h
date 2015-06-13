//
//  SFAPIClient.h
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cockie Monster Team. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SalesforceRestAPI/SFRestAPI.h>

@interface SFAPIClient : NSObject

- (void)testGet;

- (void)GETQueryWithParams:(NSDictionary *)params
                 onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                   onError:(void(^)(NSError *error))errorBlock;

- (void)POSTQueryWithParams:(NSDictionary *)params
                  onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                    onError:(void(^)(NSError *error))errorBlock;

- (void)PUTQueryWithParams:(NSDictionary *)params
                 onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                   onError:(void(^)(NSError *error))errorBlock;

- (void)DELETEQueryWithParams:(NSDictionary *)params
                    onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                      onError:(void(^)(NSError *error))errorBlock;

- (void)sendQueryWithSFRestMethod:(SFRestMethod)restMethod
                           params:(NSDictionary *)params
                        onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                          onError:(void(^)(NSError *error))errorBlock;

#pragma mark - Life Cycle

+ (id)sharedApiClient;

@end
