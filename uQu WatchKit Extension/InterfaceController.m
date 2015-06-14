//
//  InterfaceController.m
//  uQu WatchKit Extension
//
//  Created by François Benaiteau on 13/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchKit/WKInterfaceController.h>
#import "WKQuestionRow.h"
@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *questionLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@property (nonatomic, assign)BOOL updating;
@property (nonatomic, strong)NSDictionary* questions;
@end


@implementation InterfaceController
- (IBAction)newQuestion 
{
    [self presentTextInputControllerWithSuggestions:@[] allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
        NSString * question = results.firstObject;
        if (question != nil) {
            [self presentControllerWithName:@"watch.newquestion" context:question];
            [self.questionLabel setText:question];

        }
    }];
}


- (void)getQuestions
{
    [self.table setNumberOfRows:1 withRowType:@"watch.question.row"];
    
    WKQuestionRow* row = [self.table rowControllerAtIndex:0];
    [row.label setText:@"Loading Question"];
    [WKInterfaceController openParentApplication:@{@"request": @"questions"} reply:^(NSDictionary *replyInfo, NSError *error) {
        // TODO: process reply data
        __block NSInteger i = 0;
        self.questions = replyInfo;
        [self.table setNumberOfRows:replyInfo.allKeys.count withRowType:@"watch.question.row"];       
        [replyInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            WKQuestionRow* row = [self.table rowControllerAtIndex:i];        
            [row.label setText:key];
            i++;
        }];
    }];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex
{
    if([segueIdentifier isEqualToString:@"question.segue"]){
        NSString* key = self.questions.allKeys[rowIndex];
        return self.questions[key];
    }
    return nil;
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
