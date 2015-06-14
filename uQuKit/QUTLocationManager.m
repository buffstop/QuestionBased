//
//  QUTLocationManager.m
//  Qute
//
//  Created by Andreas Buff on 14/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import "QUTLocationManager.h"

@interface QUTLocationManager () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSInteger accuracy;
@property (nonatomic, copy) void (^successBlock)(CLLocation *userPosition);
@property (nonatomic, copy) void (^errorBlock)(NSError *error);
@end

@implementation QUTLocationManager

- (void)getUserLocationOnSuccess:(void(^)(CLLocation *userPosition))successBlock
                         onError:(void(^)(NSError *error))errorBlock;
{
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *bestLocation = [locations firstObject];
    for (CLLocation *curLocation in locations) {
        if (curLocation.horizontalAccuracy >= 0) {
            if (curLocation.horizontalAccuracy < bestLocation.horizontalAccuracy) {
                bestLocation = curLocation;
            }
        }
    }
    if (bestLocation) {
        self.successBlock(bestLocation);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}

#pragma mark - Accessors

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        self.accuracy = 150;
    }
    return self;
}

+ (instancetype)sharedManager
{
    static QUTLocationManager *sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [QUTLocationManager new];
    });
    return sharedManager;
}

@end
