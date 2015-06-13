//
//  CreateQuestionViewController.m
//  Qute
//
//  Created by François Benaiteau on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import "CreateQuestionViewController.h"
@import MapKit;

@interface CreateQuestionViewController ()<MKMapViewDelegate,UITextViewDelegate>
- (IBAction)chooseLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property(nonatomic, copy)NSString* placeholder;
@end

@implementation CreateQuestionViewController

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.placeholder]) {
        textView.text = nil;
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (IsEmpty(textView.text)) {
        textView.text = self.placeholder;
    }
    return YES;
}

- (void)dismissKeyboard:(UITapGestureRecognizer*)gesture
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:self
                                         forEvent:nil];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.placeholder = @"Enter your question";

    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseLocation:(id)sender {
    
}
@end
