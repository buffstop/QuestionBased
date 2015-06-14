//
//  QuestionInterfaceController.h
//  uQu
//
//  Created by François Benaiteau on 14/06/15.
//  Copyright (c) 2015 Cookie Monster. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface QuestionInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *questionLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceButton* yes;
@property (weak, nonatomic) IBOutlet WKInterfaceButton* no;
@end
