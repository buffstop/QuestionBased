//
//  NSDate+QUTAdditions.m
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import "NSDate+QUTAdditions.h"

@implementation NSDate (QUTAdditions)

+ (NSDate *)qut_in24hours
{
    return [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60];
}
@end
