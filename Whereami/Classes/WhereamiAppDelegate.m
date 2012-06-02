//
//  WhereamiAppDelegate.m
//  Whereami
//
//  Created by Marc Mauger on 11/26/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "WhereamiAppDelegate.h"

@implementation WhereamiAppDelegate

@synthesize window, mapViewStyle;

static const int WMAPVIEW_STANDARD	= 0;
static const int WMAPVIEW_SATELLITE	= 1;
static const int WMAPVIEW_HYBRID	= 2;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
	dtFormat = [[NSDateFormatter alloc] init];
	[dtFormat setDateStyle:NSDateFormatterMediumStyle];
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDistanceFilter:kCLDistanceFilterNone];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];

	NSMutableArray *mapPoints = 
	[NSKeyedUnarchiver unarchiveObjectWithFile:[self mapPointsArrayPath]];
	for (id obj in mapPoints) {
		[mapView addAnnotation:obj];
	}
	//[locationManager startUpdatingLocation];
	//[locationManager startUpdatingHeading];
	[mapView setShowsUserLocation:YES];

	[window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	NSLog(@"%@", NSStringFromSelector(_cmd));
	[self archiveMapPoints];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	NSLog(@"%@", NSStringFromSelector(_cmd));
	[self archiveMapPoints];
}

- (void)dealloc {
	[locationManager setDelegate:nil];
	[dtFormat release];
	[window release];
    [super dealloc];
}

- (void)findLocation
{
	[locationManager startUpdatingLocation];
	[activityIndicator startAnimating];
	[locationTitleField setHidden:YES];
}

- (void)foundLocation
{
	[locationTitleField setText:@""];
	[activityIndicator stopAnimating];
	[locationTitleField setHidden:NO];
	[locationManager stopUpdatingLocation];
}

- (IBAction)changeMapViewStyle:(id)sender
{
	int idx = [mapViewStyle selectedSegmentIndex];
	NSLog(@"Map View changed: %d", idx);
	
	if (idx == WMAPVIEW_STANDARD) {
		[mapView setMapType:MKMapTypeStandard];
	} else if (idx == WMAPVIEW_SATELLITE) {
		[mapView setMapType:MKMapTypeSatellite];
	} else if (idx == WMAPVIEW_HYBRID) {
		[mapView setMapType:MKMapTypeHybrid];
	}
}

- (NSString *)mapPointsArrayPath
{
	return pathInDocumentDirectory(@"MapPoints.data");
}

- (void)archiveMapPoints
{
	NSMutableArray *mapPoints = [NSMutableArray array];
	
	for (id obj in [mapView annotations]) {
		if ([obj conformsToProtocol:@protocol(NSCoding)]) {
			[mapPoints addObject:obj];
		}
	}
	// Get the full path of our possession archive file
	NSString *mapPointsPath = [self mapPointsArrayPath];
	NSLog(@"Arching map points to %@", mapPointsPath);
	[NSKeyedArchiver archiveRootObject:mapPoints toFile:mapPointsPath];
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
	NSString *titleWithDate = [NSString stringWithFormat:@"%@: %@", 
							   [dtFormat stringFromDate:[newLocation timestamp]],
							   [locationTitleField text]];
	NSLog(@"Date for title: %@", titleWithDate);
	
	MapPoint *mp = [[MapPoint alloc]
					initWithLocation: newLocation
					title:titleWithDate];
	[mapView addAnnotation:mp];
	[mp release];
	
	[self foundLocation];
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
	NSLog(@"%@", NSStringFromSelector(_cmd));

	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	NSLog(@"Got map point: %@", [mp description]);
	MKCoordinateRegion region = 
		MKCoordinateRegionMakeWithDistance([mp coordinate], 250, 250);
	[mv setRegion:region animated:YES];
}


#pragma mark UITextFieldDelegate functions

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
	[self findLocation];
	[tf resignFirstResponder];
	return YES;
}

@end
