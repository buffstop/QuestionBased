//
//  QUTPollingManager.m
//  uQu
//
//  Created by Andreas Buff on 14/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//
#import "QUTPollingManager.h"

#import "SFAPIClient.h"
#import "QUTAnswer.h"
#import "QUTQuestion.h"

NSString *QUTNotificationNewAnswers = @"QUTNotificationNewAnswers";
NSString *QUTNotificationNewQuestions = @"QUTNotificationNewQuestions";

@interface QUTPollingManager ()
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSArray *previousResult;
@end

@implementation QUTPollingManager

- (void)poll
{
//    [[SFAPIClient sharedApiClient] getAllAnswersOnSuccess:^(NSArray *result) {
//        <#code#>
//    } onError:^(NSError *error) {
//        NSLog(@"Uups: %@", error);
//    }];
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timer = [NSTimer timerWithTimeInterval:3.5 target:self selector:@selector(poll) userInfo:nil repeats:YES];
        //TODO:
    }
    return self;
}
@end
