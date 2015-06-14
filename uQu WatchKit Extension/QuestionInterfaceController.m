//
//  QuestionInterfaceController.m
//  uQu
//
//  Created by François Benaiteau on 14/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//

#import "QuestionInterfaceController.h"

@interface QuestionInterfaceController ()
@property(nonatomic, copy)NSString* question;
@property(nonatomic, copy)NSString* questionId;
@end

@implementation QuestionInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // context is question name
    if ([context isKindOfClass:[NSDictionary class]]) {
        self.questionId = context[@"Id"];
        self.question = context[@"question__c"];
        [self.questionLabel setText:self.question];
    }
}


- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)selectNo {
    [self sendResult:@"No"];
}
- (IBAction)selectYes {
    [self sendResult:@"Yes"];
}

- (IBAction)dismiss {
    //    SFAPIClient sharedApiClient
    [self popController];
}

-(void)sendResult:(NSString*)answer{
    NSDictionary* response = @{@"request": @"sendanswer",
                               @"questionId": self.questionId,
                               @"answer": answer};
    [WKInterfaceController openParentApplication:response reply:^(NSDictionary *replyInfo, NSError *error) {
        if([replyInfo[@"result"]  isEqual: @1]){
            // success
        }else{
            
        }
    }];

}

@end



