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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[SFAPIClient sharedApiClient] test];
//    [[SFAPIClient sharedApiClient] testCreateQuestion];
}
- (IBAction)segmentedControlValueHasChanged:(UISegmentedControl *)sender
{
    //TODO:
}

@end
