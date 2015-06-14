//
//  NewQuestionInterfaceController.m
//  uQu
//
//  Created by François Benaiteau on 14/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//

#import "NewQuestionInterfaceController.h"

@interface NewQuestionInterfaceController ()
@property(nonatomic, copy)NSString* question;
@end

@implementation NewQuestionInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // context is question name
    if ([context isKindOfClass:[NSString class]]) {
        self.question = context;
       [self.questionLabel setText:self.question];
    }

    CLLocationCoordinate2D coordiante = CLLocationCoordinate2DMake(52.50591, 13.29872);
    [self.myMap addAnnotation:coordiante withImage:nil centerOffset:CGPointZero];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
            [self.questionLabel setText:self.question];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



