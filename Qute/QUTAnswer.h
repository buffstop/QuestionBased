//
//  QUTAnswer.h
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QUTBaseModel.h"

@interface QUTAnswer : QUTBaseModel
@property (strong, nonatomic) NSString *questionid;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *ownerId;

@end
