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

@property (strong, nonatomic) NSArray *previousAnswers;
@property (strong, nonatomic) NSArray *previousQuestions;
@end

@implementation QUTPollingManager

//- (void)poll
//{
//    [[SFAPIClient sharedApiClient] getAllAnswersOnSuccess:^(NSArray *result) {
//        //sort array by date
//        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
//                                            sortDescriptorWithKey:@"createDate"
//                                            ascending:YES];
//        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
//        NSMutableArray *sortedArray = [[result
//                                     sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
//        if (sortedArray.count > self.previousAnswers.count) {
//            NSInteger newCount = sortedArray.count - self.previousAnswers.count;
//            NSMutableArray *newAnswers = [NSMutableArray new];
//            for (NSInteger i = 0; i < newCount; ++i) {
//                [newAnswers addObject:[sortedArray lastObject]];
//                [sortedArray removeObject:[sortedArray lastObject]];
//            }
////            NSDictionary *infoDict = @{@"answers":newAnswers};
//            self.previousAnswers = sortedArray;
//            UILocalNotification *notification = [[UILocalNotification alloc] init];
//            notification.fireDate = [NSDate date];
//            notification.alertBody = @"New Answers";
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }
//    } onError:^(NSError *error) {
//        NSLog(@"Uups: %@", error);
//    }];
//}

- (void)pullAnswers
{
    [[SFAPIClient sharedApiClient] getAllAnswersOnSuccess:^(NSArray *result) {
        if (result.count > self.previousQuestions.count) {
            self.previousQuestions = result;
            QUTAnswer *answer = [result lastObject];
            
            [[SFAPIClient sharedApiClient] getQuestioWithId:answer.questionid onSuccess:^(QUTQuestion *result) {
                NSString *message = [NSString stringWithFormat:@"%@\n%@", result.question, answer.text];
                UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Answer" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } onError:^(NSError *error) {
                NSLog(@"Uups: %@", error);
            }];
        }
    } onError:^(NSError *error) {
        NSLog(@"Uups: %@", error);
    }];
}

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(pullAnswers) userInfo:nil repeats:YES];
    }
    return self;
}

+ (instancetype)sharedPoller
{
    static QUTPollingManager *shared;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [QUTPollingManager new];
    });
    return shared;
}
@end
