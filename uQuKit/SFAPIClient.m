//
//  SFAPIClient.m
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cockie Monster Team. All rights reserved.
//

#import "SFAPIClient.h"

#import "SFRestRequest+QUTAdditions.h"
#import "QUTLocationManager.h"

#import <SalesforceSDKCore/SFJsonUtils.h>
#import <SalesforceRestAPI/SFRestAPI.h>
#import <SalesforceRestAPI/SFRestRequest.h>
#import <SalesforceSDKCore/SFSecurityLockout.h>
#import <SalesforceSDKCore/SFAuthenticationManager.h>
#import <SalesforceSDKCore/SFDefaultUserManagementViewController.h>
#import <SalesforceSDKCore/SFUserAccountManager.h>

@interface SFAPIClient () <SFRestDelegate>
@property (strong, nonatomic) NSMutableDictionary *successHandlerForRequest;
@property (strong, nonatomic) NSMutableDictionary *errorHandlerForRequest;
@end

@implementation SFAPIClient

#pragma mark - Test

- (void)test
{
    [self getAllQuestionsOnSuccess:^(NSArray *result) {
        NSLog(@"Success: %@", result);
    } onError:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testGetSelect
{
    NSDictionary *params = [self selectParamsForQueryWithSelectString:@"select id, name from Answer__c"];
    [self GETQueryWithParams:params onSuccess:^(NSDictionary *responsDict) {
        NSLog(@"Success: %@", responsDict);
    } onError:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testGetParams
{
    NSDictionary *params = @{@"q":@"select id, name from Answer__c"};
    [self GETQueryWithParams:params onSuccess:^(NSDictionary *responsDict) {
        NSLog(@"Success: %@", responsDict);
    } onError:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)testCreateQuestion
{
    QUTQuestion *testQ = [QUTQuestion new];
//    testQ.expiredate = [NSDate qut_in24hours];
    testQ.latitude = @32;
    testQ.longitude = @32;
    testQ.question = @"Why the fuck!";
    
    [[SFAPIClient sharedApiClient] createQuestionWithParams:[testQ jsonDict] onSuccess:^(NSDictionary *responsDict) {
        NSLog(@"%@", responsDict);
        NSString *qId = responsDict[@"id"];
        [self testCreateAnswerWithQId:qId];
    } onError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)testCreateAnswerWithQId:(NSString *)qId
{
    QUTAnswer *testQ = [QUTAnswer new];
    testQ.text = @"Yes";
//    testQ.uid = qId;
    testQ.questionid = qId;
    [[SFAPIClient sharedApiClient] createAnswerWithParams:[testQ jsonDict] onSuccess:^(NSDictionary *responsDict) {
        NSLog(@"%@", responsDict);
    } onError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - To Use

- (void)createType:(NSString *)type
            params:(NSDictionary *)params
         onSuccess:(void(^)(NSDictionary * responsDict))successBlock
           onError:(void(^)(NSError *error))errorBlock;
{
    NSString *path = [NSString stringWithFormat:@"/v33.0/sobjects/%@", type];
    [self sendQueryWithSFRestMethod:SFRestMethodPOST path:path params:params onSuccess:successBlock onError:errorBlock];
}

#pragma mark User

- (NSString *)getUserID
{
    return [SFAuthenticationManager sharedManager].idCoordinator.idData.userId;
}

#pragma mark Answer
- (void)getAllAnswersOnSuccess:(void(^)(NSArray *result))successBlock
                       onError:(void(^)(NSError *error))errorBlock;
{
    NSString *select = @"SELECT Id,createdDate,OwnerId,questionid__c,text__c FROM Answer__c";
    [self GETQueryWithSelectString:select onSuccess:^(NSDictionary *responsDict) {
        NSArray *records = [QUTAnswer objectsFromRepsonseJsonDict:responsDict];
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"createDate"
                                            ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        records = [records sortedArrayUsingDescriptors:sortDescriptors];
        
        if (successBlock) {  successBlock(records); }
    } onError:errorBlock];
}

- (void)getAnswerWithQuestionId:(NSString *)questionId
              onSuccess:(void(^)(QUTAnswer * result))successBlock
                onError:(void(^)(NSError *error))errorBlock;
{
    NSString *select = [NSString stringWithFormat:@"SELECT Id,createdDate,OwnerId,questionid__c,text__c FROM Answer__c WHERE questionid__c = %@", questionId];
    [self GETQueryWithSelectString:select onSuccess:^(NSDictionary *responsDict) {
        QUTAnswer *result = [[QUTAnswer objectsFromRepsonseJsonDict:responsDict] firstObject];
        if (successBlock) { successBlock(result); }
    } onError:errorBlock];
}

- (void)createAnswerWithParams:(NSDictionary *)params
         onSuccess:(void(^)(NSDictionary * responsDict))successBlock
           onError:(void(^)(NSError *error))errorBlock
{
    [self createType:@"answer__c" params:params onSuccess:successBlock onError:errorBlock];
}

#pragma mark Questions

- (void)getAllQuestionsOnSuccess:(void(^)(NSArray *result))successBlock
                         onError:(void(^)(NSError *error))errorBlock;
{
    NSString *select = @"SELECT Id,createdDate,latitude__c,longitude__c,OwnerId,question__c FROM Question__c";
    [self GETQueryWithSelectString:select onSuccess:^(NSDictionary *responsDict) {
        NSArray *records = [QUTQuestion objectsFromRepsonseJsonDict:responsDict];
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"createDate"
                                            ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        records = [records sortedArrayUsingDescriptors:sortDescriptors];
        
        NSLog(@"records: %@", records.firstObject);
        if (successBlock) {  successBlock(records); }
    } onError:errorBlock];
}

- (void)getAllQuestionsOfCurrentUserOnSuccess:(void(^)(NSArray *result))successBlock
                                      onError:(void(^)(NSError *error))errorBlock
{
    [self getAllQuestionsOfUserWithID:[[SFAPIClient sharedApiClient] getUserID]
                            onSuccess:successBlock
                              onError:errorBlock];
}

- (void)getNearbyQuestionsOnSuccess:(void(^)(NSArray *result))successBlock
                            onError:(void(^)(NSError *error))errorBlock;
{
//    [[QUTLocationManager sharedManager] getUserLocationOnSuccess:^(CLLocation *userPosition) {
//        NSString *select = [NSString stringWithFormat:@"SELECT Id,latitude__c,longitude__c,OwnerId,question__c FROM Question__c where OwnerId != \'%@\'", [[SFAPIClient sharedApiClient] getUserID]];
//        [self GETQueryWithSelectString:select onSuccess:^(NSDictionary *responsDict) {
//            NSArray *records = [QUTQuestion objectsFromRepsonseJsonDict:responsDict];
//            CLCircularRegion *circle = [[CLCircularRegion alloc] initWithCenter:userPosition.coordinate radius:1000 identifier:nil];
//            NSMutableArray *nearby = [NSMutableArray new];
//            for (QUTQuestion *curQ in records) {
//                if ((curQ.latitude && curQ.longitude) && (![curQ.latitude isKindOfClass:[[NSNull null] class]] && ![curQ.longitude isKindOfClass:[[NSNull null] class]])) {
//                    CLLocationCoordinate2D curCoordinate = CLLocationCoordinate2DMake(curQ.latitude.doubleValue, curQ.longitude.doubleValue);
//                    if ([circle containsCoordinate:curCoordinate]) {
//                        [nearby addObject:curQ];
//                    }
//                }
//            }
//            if (successBlock) {  successBlock(nearby); }
//        } onError:errorBlock];
//    } onError:errorBlock];
    
        NSString *select = [NSString stringWithFormat:@"SELECT Id,createdDate, latitude__c,longitude__c,OwnerId,question__c FROM Question__c where OwnerId != \'%@\'", [[SFAPIClient sharedApiClient] getUserID]];
        [self GETQueryWithSelectString:select onSuccess:^(NSDictionary *responsDict) {
            NSArray *records = [QUTQuestion objectsFromRepsonseJsonDict:responsDict];
            
            NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                sortDescriptorWithKey:@"createDate"
                                                ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
            records = [records sortedArrayUsingDescriptors:sortDescriptors];
            
            if (successBlock) {  successBlock(records); }
        } onError:errorBlock];

}

- (void)getAllQuestionsOfUserWithID:(NSString *)userId
                          onSuccess:(void(^)(NSArray *result))successBlock
                            onError:(void(^)(NSError *error))errorBlock;
{
    NSString *select = [NSString stringWithFormat:@"SELECT Id,createdDate,latitude__c,longitude__c,OwnerId,question__c FROM Question__c where OwnerId = \'%@\'", userId];
    [self GETQueryWithSelectString:select onSuccess:^(NSDictionary *responsDict) {
        NSArray *records = [QUTQuestion objectsFromRepsonseJsonDict:responsDict];
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"createDate"
                                            ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        records = [records sortedArrayUsingDescriptors:sortDescriptors];
        
        if (successBlock) {  successBlock(records); }
    } onError:errorBlock];
}

- (void)getQuestioWithId:(NSString *)answerId
                      onSuccess:(void(^)(QUTQuestion * result))successBlock
                        onError:(void(^)(NSError *error))errorBlock;
{
    NSString *select = [NSString stringWithFormat:@"SELECT Id,createdDate,latitude__c,longitude__c,Name,OwnerId,question__c FROM Question__c WHERE Id = \'%@\'", answerId];
    [self GETQueryWithSelectString:select onSuccess:^(NSDictionary *responsDict) {
        QUTQuestion *result = [[QUTQuestion objectsFromRepsonseJsonDict:responsDict] firstObject];
        if (successBlock) { successBlock(result); }
    } onError:errorBlock];
}

- (void)createQuestionWithParams:(NSDictionary *)params
                     onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                       onError:(void(^)(NSError *error))errorBlock
{
    [self createType:@"question__c" params:params onSuccess:successBlock onError:errorBlock];
}

#pragma mark - Other

//TODO: get non expired answers

//TODO: get questions around my location

//TODO: create question
//- (QUTQuestion *)createQuestionWithExpiredate:(NSDate *)expiredate latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude question:(NSString *)question ownerId:(NSString *)OwnerId
//{
//    
//}



#pragma mark - Selects

- (void)GETQueryWithSelectString:(NSString *)select
                 onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                   onError:(void(^)(NSError *error))errorBlock;
{
    [self GETQueryWithParams:[self selectParamsForQueryWithSelectString:select]
                   onSuccess:successBlock
                     onError:errorBlock];
}

#pragma mark - Queries with Params

- (void)GETQueryWithParams:(NSDictionary *)params
                       onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                         onError:(void(^)(NSError *error))errorBlock;
{
        [self sendQueryWithSFRestMethod:SFRestMethodGET params:params onSuccess:successBlock onError:errorBlock];
}

- (void)sendQueryWithSFRestMethod:(SFRestMethod)restMethod
                           params:(NSDictionary *)params
                        onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                          onError:(void(^)(NSError *error))errorBlock;
{
    NSString *path = @"/v33.0/query";
    [self sendQueryWithSFRestMethod:restMethod path:path params:params onSuccess:successBlock onError:errorBlock];
}

- (void)sendQueryWithSFRestMethod:(SFRestMethod)restMethod
                             path:(NSString *)path
                           params:(NSDictionary *)params
                        onSuccess:(void(^)(NSDictionary * responsDict))successBlock
                          onError:(void(^)(NSError *error))errorBlock;
{
    
    
    NSDictionary *queryParams = params;
    //    NSDictionary *queryParams = ([params length] == 0
    //                                 ? nil
    //                                 : (NSDictionary *)[SFJsonUtils objectFromJSONString:params]
    //                                 );
    
    SFRestRequest *request = [SFRestRequest requestWithMethod:restMethod path:path queryParams:queryParams];
    
    [self addHandlerForRequest:request successHandler:successBlock errorHandler:errorBlock];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - Params

- (NSDictionary *)selectParamsForQueryWithSelectString:(NSString *)select
{
    return @{@"q":select};
}

#pragma mark - Block Management

- (void)addHandlerForRequest:(SFRestRequest *)request successHandler:(void(^)(NSDictionary * responsDict))successBlock
                     errorHandler:(void(^)(NSError *error))errorBlock
{
    self.successHandlerForRequest[request] = successBlock;
    self.errorHandlerForRequest[request] = errorBlock;
}

- (void)removeHandlerForRequest:(SFRestRequest *)request
{
    [self.successHandlerForRequest removeObjectForKey:request];
    [self.errorHandlerForRequest removeObjectForKey:request];
}


#pragma mark - SFRestDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)dataResponse
{
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^successHandler)() = self.successHandlerForRequest[request];
        [self removeHandlerForRequest:request];
        if (successHandler) {
            successHandler(dataResponse);
        }
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^errorHandler)() = self.errorHandlerForRequest[request];
        [self removeHandlerForRequest:request];
        if (errorHandler) {
            errorHandler(error);
        }
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^errorHandler)() = self.errorHandlerForRequest[request];
        [self removeHandlerForRequest:request];
        if (errorHandler) {
            errorHandler([NSError errorWithDomain:@"com.cockie.monster" code:1 userInfo:nil]);
        }
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^errorHandler)() = self.errorHandlerForRequest[request];
        [self removeHandlerForRequest:request];
        if (errorHandler) {
            errorHandler([NSError errorWithDomain:@"com.cockie.monster" code:2 userInfo:nil]);
        }
    });
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.successHandlerForRequest = [NSMutableDictionary new];
        self.errorHandlerForRequest = [NSMutableDictionary new];
    }
    return self;
}

+ (id)sharedApiClient
{
    static SFAPIClient *sharedApiClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedApiClient = [self new];
    });
    return sharedApiClient;
}

@end
