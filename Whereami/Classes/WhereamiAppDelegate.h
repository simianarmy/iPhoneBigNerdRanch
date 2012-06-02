//
//  WhereamiAppDelegate.h
//  Whereami
//
//  Created by Marc Mauger on 11/26/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"

@interface WhereamiAppDelegate : NSObject 
	<UIApplicationDelegate, CLLocationManagerDelegate, MKMapViewDelegate> {
    UIWindow *window;
	CLLocationManager *locationManager;
	NSDateFormatter *dtFormat;
	
	IBOutlet MKMapView *mapView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UITextField *locationTitleField;
	IBOutlet UISegmentedControl *mapViewStyle;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mapViewStyle;

- (IBAction)changeMapViewStyle:(id)sender;
- (void)findLocation;
- (void)foundLocation;
- (NSString *)mapPointsArrayPath;
- (void)archiveMapPoints;

@end

