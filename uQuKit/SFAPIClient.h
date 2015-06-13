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
#import "NSDictionary+QUTADDITIONS.h"

@interface SFAPIClient : NSObject

#pragma mark - Test

- (void)test;

- (void)testGetSelect;

- (void)testGetParams;

- (void)testCreateQuestion;

- (void)testCreateAnswerWithQId:(NSString *)qId;

#pragma mark - API
#pragma mark User

- (NSString *)getUserName;

#pragma mark Answer

- (void)getAllAnswersOnSuccess:(void(^)(NSArray *result))successBlock
                       onError:(void(^)(NSError *error))errorBlock;

- (void)getAnswerWithQuestionId:(NSString *)questionId
                      onSuccess:(void(^)(QUTAnswer * result))successBlock
                        onError:(void(^)(NSError *error))errorBlock;

/*
 Make sure you set the Questions ID, to know what it is the answer for.
 */
- (void)createAnswerWithParams:(NSDictionary *)params
                     onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                       onError:(void(^)(NSError *error))errorBlock;

#pragma mark Question

- (void)getAllQuestionsOnSuccess:(void(^)(NSArray *result))successBlock
                         onError:(void(^)(NSError *error))errorBlock;

- (void)getQuestioWithId:(NSString *)answerId
               onSuccess:(void(^)(QUTQuestion * result))successBlock
                 onError:(void(^)(NSError *error))errorBlock;
/*
 Return dict looks like this:
{
    errors =     (
    );
    id = a012000001nu5ktAAA;
    success = 1;
}
 You need the ID for creating an answer to the created question.
*/
- (void)createQuestionWithParams:(NSDictionary *)params
                       onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                         onError:(void(^)(NSError *error))errorBlock;

#pragma mark - Life Cycle

+ (id)sharedApiClient;

@end
