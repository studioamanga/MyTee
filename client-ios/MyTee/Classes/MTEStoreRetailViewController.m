//
//  MTEStoreRetailViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 6/10/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEStoreRetailViewController.h"

#import "MTEStore.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface MTEStoreRetailViewController ()

@property (nonatomic, weak) IBOutlet MKMapView * mapView;
@property (nonatomic, strong) CLGeocoder * geocoder;

- (NSString*)storeLocation;

@end

@implementation MTEStoreRetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.geocoder = [CLGeocoder new];
    
    self.mapView.layer.borderWidth = 1;
    self.mapView.layer.cornerRadius = 4;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString * geocodingAddress = [self storeLocation];
    
    if (geocodingAddress)
    {
        [self.geocoder geocodeAddressString:geocodingAddress
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         if (!error && [placemarks count] > 0)
                         {
                             CLPlacemark * placemark = [placemarks objectAtIndex:0];
                             [self.mapView setRegion:MKCoordinateRegionMake(placemark.location.coordinate, MKCoordinateSpanMake(1, 1)) animated:YES];
                             MKPointAnnotation * pointAnnotation = [[MKPointAnnotation alloc] init];
                             pointAnnotation.coordinate = placemark.location.coordinate;
                             pointAnnotation.title = self.store.name;
                             [self.mapView addAnnotation:pointAnnotation];
                         }
                     }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.mapView.delegate = nil;
    [self.geocoder cancelGeocode];
    self.geocoder = nil;
}

#pragma mark - Map view

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    MKPinAnnotationView * newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    
    newAnnotation.pinColor = MKPinAnnotationColorRed;
    newAnnotation.animatesDrop = YES; 
    newAnnotation.canShowCallout = YES;
    [newAnnotation setSelected:YES animated:YES]; 
    
    return newAnnotation;
}

#pragma mark - Actions

- (NSString*)storeLocation
{
    if (self.store.address.length > 0)
        return self.store.address;
    
    return self.store.name;
}

- (IBAction)presentActionSheet:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Maps", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

#pragma mark - Action Sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSURL * URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", [self storeLocation]]];
        [[UIApplication sharedApplication] openURL:URL];
    }
}

@end
