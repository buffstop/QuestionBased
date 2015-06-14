//
//  NewQuestionInterfaceController.h
//  uQu
//
//  Created by François Benaiteau on 14/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NewQuestionInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceMap* myMap;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *questionLabel;
@end
