//
//  QUTBaseModel.m
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import "QUTBaseModel.h"

@implementation QUTBaseModel

+ (NSArray *)objectsFromRepsonseJsonDict:(NSDictionary *)jsonDict
{
    NSArray *records = jsonDict[@"records"];
    NSMutableArray *objects = [NSMutableArray new];
    for (NSDictionary *curRecord in records) {
        id curObject = [self fromJsonDict:curRecord];
        [objects addObject:curObject];
    }
    
    return objects;
}

+ (instancetype)fromJsonDict:(NSDictionary *)jsonDict
{
    NSAssert(false, @"Overwrite in subclass");
    return nil;
}

- (NSDictionary *)jsonDict;
{
    NSAssert(false, @"Overwrite in subclass");
    return nil;
}

@end
