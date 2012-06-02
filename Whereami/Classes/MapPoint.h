//
//  MapPoint.h
//  Whereami
//
//  Created by Marc Mauger on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKReverseGeocoder.h>

@interface MapPoint : NSObject 
<MKAnnotation, MKReverseGeocoderDelegate, NSCoding> {
	NSString *title;
	NSString *subtitle;
	//CLLocationCoordinate2D coordinate;
	CLLocation *location;
	MKReverseGeocoder *reverseGeocoder;
}
@property (nonatomic, copy) CLLocation *location;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithLocation:(CLLocation *)c title:(NSString *)t;
- (id)initWithLocation:(CLLocation *)c title:(NSString *)t 
				subTitle:(NSString *)subt;
- (CLLocationCoordinate2D)coordinate;

@end
