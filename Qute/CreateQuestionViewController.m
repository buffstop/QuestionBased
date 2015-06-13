//
//  CreateQuestionViewController.m
//  Qute
//
//  Created by François Benaiteau on 13/06/15.
//  Copyright (c) 2015 Cookie Monster Team. All rights reserved.
//

#import "CreateQuestionViewController.h"
#import <S2MToolbox/S2MShopFinderController.h>
#import <S2MToolbox/S2MCalloutAnnotation.h>
#import <AutoLayoutTextViews/ALAutoResizingTextView.h>
#import "QUTQuestion.h"

@import MapKit;

@interface CreateQuestionViewController ()<MKMapViewDelegate,UITextViewDelegate, S2MShopFinderSearchDelegate, S2MShopFinderMapSpecialsDelegate, UIAlertViewDelegate>
- (IBAction)chooseLocation:(id)sender;
@property (weak, nonatomic) IBOutlet ALAutoResizingTextView *questionTextView;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property(nonatomic, strong)S2MShopFinderController* locationController;
@property(nonatomic, strong)id<MKAnnotation> selectedLocationAnnotation;
@end

@implementation CreateQuestionViewController

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    self.sendButton.enabled = self.selectedLocationAnnotation != nil && !IsEmpty(self.questionTextView.text);
    if([text isEqualToString:@"\n"]) 
    {
        [textView resignFirstResponder];
        return NO;
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
    self.title = @"New Question";
//    self.sendButton.enabled = self.selectedLocationAnnotation != nil && !IsEmpty(self.questionTextView.text);
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:gesture];
    self.locationController = [[S2MShopFinderController alloc] init];
    self.locationController.searchDelegate = self;
    self.locationController.mapSpecialsDelegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendQuestion:(id)sender 
{
    QUTQuestion* question = [QUTQuestion new];
    question.question = self.questionTextView.text;
    question.latitude = @(52.50591);
    question.longitude = @(13.29872);

    // TODO: send question
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"uQu" message:@"Your question has been submitted!" delegate:self  cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chooseLocation:(id)sender 
{
    self.locationController.searchMode = S2MShopFinderSearchModeKeyword;

    [self presentViewController:self.locationController animated:YES completion:^{
        [self.locationController startLocatingIgnoreSelection:YES];
    }];
}

#pragma mark - S2MShopFinderSearchDelegate

-(void)shopFinder:(S2MShopFinderController *)shopFinder searchTerm:(NSString *)term withResults:(void (^)(NSArray *))resultBlock
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = term;
    self.locationController.searchBar.text = term;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
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

-(void)shopFinder:(S2MShopFinderController *)shopFinder searchAtLocation:(CLLocation*)location withResults:(void (^)(NSArray *))resultBlock
{
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self shopFinder:shopFinder searchRegion:region withResults:resultBlock];
}



/**
 *  Search with region like scrolling or user location
 *
 *  @param shopFinder
 *  @param region
 *  @param resultBlock
 */
-(void)shopFinder:(S2MShopFinderController *)shopFinder searchRegion:(MKCoordinateRegion)region withResults:(void (^)(NSArray *))resultBlock
{
    //let's say we search for tankstelle
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
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

#pragma mark S2MShopFinderMapSpecialsDelegate
/**
 *  called by the mapview to display a special callout
 *
 *  @param mapView    mapView used for displaying
 *  @param annotation annotation that callout should be displayed for
 *
 *  @return View for Callout Annotation
 */

//-(MKAnnotationView *)mapView:(MKMapView *)mapView calloutViewForAnnotation:(id<MKAnnotation>)annotation
//{
//    static NSString *identifier = @"uQu";
//    MKAnnotationView* view = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//    if (!view) {
//        S2MCalloutAnnotation* customAnnotation = [[S2MCalloutAnnotation alloc] initWithAnnotation:annotation];
//        view = [[MKAnnotationView alloc] initWithAnnotation:customAnnotation reuseIdentifier:identifier];
//        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        view.enabled = YES;
//        view.canShowCallout = YES;
//
//    }
//
//    return view;
//}
/**
 *  called when the special callout was tapped
 *
 *  @param mapView    mapView used for displaying
 *  @param annotation annotation for the selected callout
 */
-(void)mapView:(MKMapView *)mapView calloutViewWasTappedForAnnotation:(id<MKAnnotation>)annotation
{
    self.selectedLocationAnnotation = annotation;
//    self.sendButton.enabled = self.selectedLocationAnnotation != nil && !IsEmpty(self.questionTextView.text);
    [self.locationController dismissViewControllerAnimated:YES completion:^{
       
    }];
}


@end
