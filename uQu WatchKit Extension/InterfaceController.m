//
//  InterfaceController.m
//  uQu WatchKit Extension
//
//  Created by François Benaiteau on 13/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//

#import "InterfaceController.h"
@import uQuKit;


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *questionLabel;
@property (nonatomic, assign)BOOL updating;
@end


@implementation InterfaceController

- (IBAction)selectNo {
    
}
- (IBAction)selectYes {
}

- (IBAction)dismiss {
}

- (void)getQuestions
{
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
