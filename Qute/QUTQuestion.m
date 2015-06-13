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
    createe.uid = jsonDict[@"id"];
    createe.OwnerId = jsonDict[@"OwnerId"];
    createe.name = jsonDict[@"Name"];
    createe.latitude = jsonDict[@"latitude__c"];
    createe.longitude = jsonDict[@"longitude__c"];
    createe.question = jsonDict[@"question__c"];
        
    return createe;
}
@end
