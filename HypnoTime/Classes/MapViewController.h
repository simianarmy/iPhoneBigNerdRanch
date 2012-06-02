//
//  MapViewController.h
//  HypnoTime
//
//  Created by Marc Mauger on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
	<CLLocationManagerDelegate, MKMapViewDelegate> {
	CLLocationManager *locationManager;
	MKMapView *mapView;
}

@end
