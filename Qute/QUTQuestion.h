//
//  QUTQuestion.h
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QUTBaseModel.h"

@interface QUTQuestion : QUTBaseModel
@property (strong, nonatomic) NSDate *expiredate;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *question;
@end
