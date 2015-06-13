//
//  InterfaceController.m
//  uQu WatchKit Extension
//
//  Created by François Benaiteau on 13/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchKit/WKInterfaceController.h>

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *questionLabel;
@property (nonatomic, assign)BOOL updating;
@end


@implementation InterfaceController
- (IBAction)newQuestion 
{
    [self presentTextInputControllerWithSuggestions:@[] allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
        NSString * question = results.firstObject;
        [self presentControllerWithName:@"watch.newquestion" context:question];
        [self.questionLabel setText:question];
    }];
}

- (IBAction)selectNo {
    
}
- (IBAction)selectYes {
}

- (IBAction)dismiss {
//    SFAPIClient sharedApiClient
}

- (void)getQuestions
{
    [WKInterfaceController openParentApplication:@{@"request": @"refreshData"} reply:^(NSDictionary *replyInfo, NSError *error) {
        // TODO: process reply data
        NSLog(@"Reply: \(replyInfo)");

    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.questionLabel setText:@"question yeah?"];
    });
//    [[SFAPIClient sharedApiClient] getAllQuestionsOnSuccess:^(NSArray *result) {
//        
//    } onError:^(NSError *error) {
//        
//    }];
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [self getQuestions];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end
