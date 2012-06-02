    //
//  MapViewController.m
//  HypnoTime
//
//  Created by Marc Mauger on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#include "MapPoint.h"

@implementation MapViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init
{
	[super initWithNibName:nil bundle:nil];
	
	// Get the tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle:@"WhereAmI"];
	
	// Create a UIIMage from a file
	UIImage *i = [UIImage imageNamed:@"Icon.png"];
	
	// Put that image on the tab item
	[tbi setImage:i];
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDistanceFilter:kCLDistanceFilterNone];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	
	mapView = [[MKMapView alloc] init];
	[mapView setDelegate:self];
	[mapView setShowsUserLocation:YES];
	
	[self setView:mapView];
	
	return self;
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[locationManager startUpdatingLocation];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[locationManager setDelegate:nil];
	[mapView release];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[locationManager stopUpdatingLocation];
}

- (void)dealloc {
	[locationManager setDelegate:nil];
	[mapView release];
    [super dealloc];
}

#pragma mark CLLocationManagerDelegate functions

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"%@", newLocation);
	// How many secs. ago was this new location created?
	NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
	// If this location was made more than 3 mins. ago, ignore it.
	if (t < -180) {
		// This is cached data, keep looking
		return;
	}
	MapPoint *mp = [[MapPoint alloc]
					initWithCoordinate:[newLocation coordinate]
					title:[newLocation description]];
	[mapView addAnnotation:mp];
	[mp release];
	
	[locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Could not find location: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
	NSLog(@"New heading: %@", newHeading);
}

#pragma mark MKMapViewDelegate functions

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = 
		MKCoordinateRegionMakeWithDistance([mp coordinate], 250, 250);
	[mv setRegion:region animated:YES];
}


@end
