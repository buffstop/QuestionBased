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

typedef NS_ENUM(NSUInteger, QUTSegmentIndex) {
    QUTLocalQuestions = 0,
    QUTMyQuestions
};

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;

@property (strong, nonatomic) NSArray *myQuestions;
@property (strong, nonatomic) NSArray *localQuestions;
@end

@implementation ViewController

- (void)reloadMyQuestions
{
    NSString *userName = [[SFAPIClient sharedApiClient] getUserName];
    [[SFAPIClient sharedApiClient] getAllQuestionsOnSuccess:^(NSArray *result) {
        self.myQuestions = result;
        [self.tableView reloadData];
    } onError:^(NSError *error) {
        NSString *message = [NSString stringWithFormat:@"An Error Occured. %@", error];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self  cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.segmentedControll.selectedSegmentIndex) {
        case QUTLocalQuestions:
            return self.localQuestions.count;
            break;
        case QUTMyQuestions:
            return self.myQuestions.count;
            break;
        default:
            return 0;
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#(NSString *)#>]
//}

#pragma mark - UITableViewDelegate

#pragma mark - Action

- (IBAction)segmentedControlValueHasChanged:(UISegmentedControl *)sender
{
    //TODO:
}

#pragma mark - Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[SFAPIClient sharedApiClient] test];
//    [[SFAPIClient sharedApiClient] testCreateQuestion];
}

@end
