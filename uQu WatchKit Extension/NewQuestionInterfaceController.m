//
//  NewQuestionInterfaceController.m
//  uQu
//
//  Created by François Benaiteau on 14/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//

#import "NewQuestionInterfaceController.h"

@interface NewQuestionInterfaceController ()

@end

@implementation NewQuestionInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // context is question name
    if ([context isKindOfClass:[NSString class]]) {
        [self.questionLabel setText:context];
    }

    // Configure interface objects here.
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



