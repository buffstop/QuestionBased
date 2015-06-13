//
//  CreateQuestionViewController.m
//  Qute
//
//  Created by François Benaiteau on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import "CreateQuestionViewController.h"
#import <S2MToolbox/S2MShopFinderController.h>

@import MapKit;

@interface CreateQuestionViewController ()<MKMapViewDelegate,UITextViewDelegate, S2MShopFinderSearchDelegate>
- (IBAction)chooseLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property(nonatomic, copy)NSString* placeholder;
@property(nonatomic, strong)S2MShopFinderController* locationController;
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
    self.locationController = [[S2MShopFinderController alloc] init];
    self.locationController.searchDelegate = self;
    
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

- (IBAction)chooseLocation:(id)sender 
{
    [self presentViewController:self.locationController animated:YES completion:^{
        
    }];
}

#pragma mark - S2MShopFinderSearchDelegate

-(void)shopFinder:(S2MShopFinderController *)shopFinder searchTerm:(NSString *)term withResults:(void (^)(NSArray *))resultBlock
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = term;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        //second search
        MKMapItem *firstHit = [response.mapItems firstObject];
        
        MKCoordinateRegion region = MKCoordinateRegionMake(firstHit.placemark.coordinate, MKCoordinateSpanMake(0.1, 0.1));
        
        [self shopFinder:shopFinder searchRegion:region withResults:^(NSArray *results) {
            if (resultBlock) {
                resultBlock(results);
            }
        }];
    }];
}

-(void)shopFinder:(S2MShopFinderController *)shopFinder searchAtLocation:(CLLocation*)location withResults:(void (^)(NSArray *))resultBlock
{
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self shopFinder:shopFinder searchRegion:region withResults:resultBlock];
}

-(void)shopFinder:(S2MShopFinderController *)shopFinder searchRegion:(MKCoordinateRegion)region withResults:(void (^)(NSArray *))resultBlock
{
    //let's say we search for tankstelle
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
//    request.naturalLanguageQuery = @"Tankstelle";
    request.region = region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:response.mapItems.count];
        for (MKMapItem *item in response.mapItems) {
            [results addObject:item.placemark];
        }
        if (resultBlock) {
            resultBlock(results);
        }
    }];
}

@end
