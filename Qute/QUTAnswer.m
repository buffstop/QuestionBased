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
    
    return createe;
}

@end
