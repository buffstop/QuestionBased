//
//  ViewController.m
//  Qute
//
//  Created by Andreas Buff on 13/06/15.
//  Copyright (c) 2015 Cockie Monster Team. All rights reserved.
//

#import "ViewController.h"

#import "SFAPIClient.h"
#import "QUTQuestion.h"
#import "NSDate+QUTAdditions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[SFAPIClient sharedApiClient] test];
//    [[SFAPIClient sharedApiClient] testCreateQuestion];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
