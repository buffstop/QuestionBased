//
//  QUTLocationManager.h
//  Qute
//
//  Created by Andreas Buff on 14/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import <Foundation/Foundation.h>


@import CoreLocation;

@interface QUTLocationManager : NSObject

- (void)getUserLocationOnSuccess:(void(^)(CLLocation *userPosition))successBlock
                         onError:(void(^)(NSError *error))errorBlock;

+ (instancetype)sharedManager;

@end
