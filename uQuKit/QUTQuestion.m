//
//  QUTQuestion.m
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import "QUTQuestion.h"

@implementation QUTQuestion

+ (instancetype)fromJsonDict:(NSDictionary *)jsonDict
{
    QUTQuestion *createe = [QUTQuestion new];
    createe.uid = jsonDict[@"Id"];
    createe.OwnerId = jsonDict[@"OwnerId"];
    createe.name = jsonDict[@"Name"];
    createe.latitude = jsonDict[@"latitude__c"];
    createe.longitude = jsonDict[@"longitude__c"];
    createe.question = jsonDict[@"question__c"];
    createe.expiredate = [NSDate new];
        
    return createe;
}

- (NSDictionary *)jsonDict
{
    NSMutableDictionary *jsonDict = [NSMutableDictionary new];
    if (self.uid) {
        jsonDict[@"Id"] = self.uid;
    }    
    
    if (self.OwnerId) {
        jsonDict[@"OwnerId"] = self.OwnerId;
    }
    
//    if (self.name) {
//        jsonDict[@"Name"] = self.name;
//    }
    
//    jsonDict[@"latitude__c"] = self.latitude;
//    jsonDict[@"longitude__c"] = self.longitude;
    jsonDict[@"question__c"] = self.question;
//    jsonDict[@"expiredate__c"] = @"2015-06-12T14:58:27.000Z";
    
    return jsonDict;
}

@end
