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
    [[SFAPIClient sharedApiClient] getAllQuestionsOfCurrentUserOnSuccess:^(NSArray *result) {
        self.myQuestions = result;
        [self.tableView reloadData];
    } onError:^(NSError *error) {
        NSString *message = [NSString stringWithFormat:@"An Error Occured. %@", error];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self  cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }];
}

- (void)reloadLocalQuestions
{
    [self.tableView reloadData];
    [[SFAPIClient sharedApiClient] getNearbyQuestionsOnSuccess:^(NSArray *result) {
        self.localQuestions = result;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"question cell"];
    QUTQuestion *q = nil;
    if (self.segmentedControll.selectedSegmentIndex == QUTMyQuestions) {
        q = self.myQuestions[indexPath.row];
    } else {
        q = self.localQuestions[indexPath.row];
    }
    
    cell.textLabel.text = q.question;
    
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - Action

- (IBAction)segmentedControlValueHasChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case QUTLocalQuestions:
            [self reloadLocalQuestions];
            break;
        case QUTMyQuestions:
            [self reloadMyQuestions];
            break;
        default:
            break;
    }
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.segmentedControll.selectedSegmentIndex = 1;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadLocalQuestions];
    [self reloadMyQuestions];
    
    //    [[SFAPIClient sharedApiClient] test];
    //    [[SFAPIClient sharedApiClient] testCreateQuestion];
}

@end
