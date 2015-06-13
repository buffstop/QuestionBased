//
//  SFAPIClient.m
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cockie Monster Team. All rights reserved.
//

#import "SFAPIClient.h"

#import <SalesforceSDKCore/SFJsonUtils.h>
#import <SalesforceRestAPI/SFRestAPI.h>
#import <SalesforceRestAPI/SFRestRequest.h>
#import <SalesforceSDKCore/SFSecurityLockout.h>
#import <SalesforceSDKCore/SFAuthenticationManager.h>
#import <SalesforceSDKCore/SFDefaultUserManagementViewController.h>

@interface SFAPIClient () <SFRestDelegate>
@property (strong, nonatomic) NSMutableDictionary *successHandlerForRequest;
@property (strong, nonatomic) NSMutableDictionary *errorHandlerForRequest;
@end

@implementation SFAPIClient

- (void)testGet
{
    NSDictionary *params = @{@"q":@"select id, name from Answer__c"};
    [self GETQueryWithParams:params onSuccess:^{
        NSLog(@"Success");
    } onError:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)GETQueryWithParams:(NSDictionary *)params
                 onSuccess:(void(^)())successBlock
                   onError:(void(^)(NSError *error))errorBlock;
{
    [self sendQueryWithSFRestMethod:SFRestMethodGET params:params onSuccess:successBlock onError:errorBlock];
}

- (void)POSTQueryWithParams:(NSDictionary *)params
                  onSuccess:(void(^)())successBlock
                    onError:(void(^)(NSError *error))errorBlock;
{
    [self sendQueryWithSFRestMethod:SFRestMethodPOST params:params onSuccess:successBlock onError:errorBlock];
}

- (void)PUTQueryWithParams:(NSDictionary *)params
                 onSuccess:(void(^)())successBlock
                   onError:(void(^)(NSError *error))errorBlock;
{
    [self sendQueryWithSFRestMethod:SFRestMethodPUT params:params onSuccess:successBlock onError:errorBlock];
}

- (void)DELETEQueryWithParams:(NSDictionary *)params
                 onSuccess:(void(^)())successBlock
                   onError:(void(^)(NSError *error))errorBlock;
{
    [self sendQueryWithSFRestMethod:SFRestMethodDELETE params:params onSuccess:successBlock onError:errorBlock];
}

- (void)sendQueryWithSFRestMethod:(SFRestMethod)restMethod
                           params:(NSDictionary *)params
                        onSuccess:(void(^)())successBlock
                          onError:(void(^)(NSError *error))errorBlock;
{
    NSString *path = @"/v33.0/query";
    
    
    NSDictionary *queryParams = params;
//    NSDictionary *queryParams = ([params length] == 0
//                                 ? nil
//                                 : (NSDictionary *)[SFJsonUtils objectFromJSONString:params]
//                                 );
    
    SFRestRequest *request = [SFRestRequest requestWithMethod:restMethod path:path queryParams:queryParams];
    
    self.successHandlerForRequest[request] = successBlock;
    self.errorHandlerForRequest[request] = errorBlock;
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - Other

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
            successHandler();
        }
    });
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^errorHandler)() = self.errorHandlerForRequest[request];
        [self removeHandlerForRequest:request];
        if (errorHandler) {
            errorHandler();
        }
    });
}

- (void)requestDidCancelLoad:(SFRestRequest *)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^errorHandler)() = self.errorHandlerForRequest[request];
        [self removeHandlerForRequest:request];
        if (errorHandler) {
            errorHandler();
        }
    });
}

- (void)requestDidTimeout:(SFRestRequest *)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        void (^errorHandler)() = self.errorHandlerForRequest[request];
        [self removeHandlerForRequest:request];
        if (errorHandler) {
            errorHandler();
        }
    });
}

#pragma mark - Life Cycle

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
