//
//  QUTBaseModel.h
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QUTBaseModel : NSObject
@property (strong, nonatomic) NSString *createdBy;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *uid;

+ (NSArray *)objectsFromRepsonseJsonDict:(NSDictionary *)jsonDict;

+ (instancetype)fromJsonDict:(NSDictionary *)jsonDict;

- (NSDictionary *)jsonDict;

@end
