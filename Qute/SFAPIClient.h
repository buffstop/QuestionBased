//
//  SFAPIClient.h
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cockie Monster Team. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QUTAnswer.h"
#import "QUTQuestion.h"

#import <SalesforceRestAPI/SFRestAPI.h>

@interface SFAPIClient : NSObject

- (void)test;

- (void)testGetSelect;

- (void)testGetParams;

#pragma mark - Convenience

#pragma mark Answers

- (void)getAllAnswersOnSuccess:(void(^)(NSArray *result))successBlock
                       onError:(void(^)(NSError *error))errorBlock;

- (void)getAnswerWithQuestionId:(NSString *)questionId
                      onSuccess:(void(^)(QUTAnswer * result))successBlock
                        onError:(void(^)(NSError *error))errorBlock;

#pragma mark Questions

- (void)getAllQuestionsOnSuccess:(void(^)(NSArray *result))successBlock
                         onError:(void(^)(NSError *error))errorBlock;

- (void)getQuestioWithId:(NSString *)answerId
               onSuccess:(void(^)(QUTQuestion * result))successBlock
                 onError:(void(^)(NSError *error))errorBlock;

#pragma mark - Seletcts

- (void)GETQueryWithSelectString:(NSString *)select
                       onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                         onError:(void(^)(NSError *error))errorBlock;

- (void)POSTQueryWithSelectString:(NSString *)select
                        onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                          onError:(void(^)(NSError *error))errorBlock;

- (void)PUTQueryWithSelectString:(NSString *)select
                       onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                         onError:(void(^)(NSError *error))errorBlock;

- (void)DELETEQueryWithSelectString:(NSString *)select
                          onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                            onError:(void(^)(NSError *error))errorBlock;

#pragma mark - Params

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
