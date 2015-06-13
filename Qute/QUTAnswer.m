//
//  QUTAnswer.m
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import "QUTAnswer.h"

@implementation QUTAnswer

+ (instancetype)fromJsonDict:(NSDictionary *)jsonDict
{
    QUTAnswer *createe = [QUTAnswer new];
    createe.uid = jsonDict[@"id"];
    createe.name = jsonDict[@"Name"];
    createe.questionid = jsonDict[@"questionid__c"];
    createe.text = jsonDict[@"text__c"];
    createe.ownerId = jsonDict[@"OwnerId"];
    
    return createe;
}

- (NSDictionary *)jsonDict
{
    NSMutableDictionary *jsonDict = [NSMutableDictionary new];
//    jsonDict[@"id"] = self.uid;
//    jsonDict[@"OwnerId"] = self.ownerId;
//    jsonDict[@"Name"] = self.name;
    jsonDict[@"text__c"] = self.text;
    if (!self.questionid) {
        self.questionid = @"a012000001nu4uvAAA";
    }
    jsonDict[@"questionid__c"] = self.questionid;
    
    return jsonDict;
}

@end
