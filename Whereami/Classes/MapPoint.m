//
//  MapPoint.m
//  Whereami
//
//  Created by Marc Mauger on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"


@implementation MapPoint
@synthesize location, title, subtitle;

- (id)initWithLocation:(CLLocation *)c title:(NSString *)t
				subTitle:(NSString *)subTitle
{
	[super init];
	
	[self setLocation:c];
	//[c release];	
	[self setTitle:t];
	[self setSubtitle:subTitle];
	
	reverseGeocoder = [[[MKReverseGeocoder alloc] init] initWithCoordinate:[self coordinate]];
	[reverseGeocoder setDelegate:self];
	[reverseGeocoder start];
	
	return self;
}

- (id)initWithLocation:(CLLocation *)c title:(NSString *)t
{
	return [self initWithLocation:c title:t subTitle:@""];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	NSString *tit = [decoder decodeObjectForKey:@"title"];
	NSString *sub = [decoder decodeObjectForKey:@"subtitle"];
	CLLocation *loc = [decoder decodeObjectForKey:@"location"];
	
	return [self initWithLocation:loc title:tit subTitle:sub];
	
	[loc release];
}

- (CLLocationCoordinate2D)coordinate
{
	return [[self location] coordinate];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"title: %@\nsubtitle: %@\nlocation: %@",
			 [self title], [self subtitle], [self location]];
}

- (void)dealloc
{
	NSLog(@"Releasing MapPoint");
	[title release];
	[subtitle release];
	[location release];
	if ([reverseGeocoder querying] == YES) {
		NSLog(@"Canceling reverseGeocoder lookup");
		[reverseGeocoder cancel];
	}
	[reverseGeocoder release];
	reverseGeocoder = NULL;
	[super dealloc];
}


#pragma mark MKReverseGeocoderDelegate functions

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	NSLog(@"reverseGeocoder failed: %@", error);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	NSLog(@"reverseGeocoder got placemark %@", placemark);
	[self setSubtitle:[NSString stringWithFormat:@"%@, %@", 
					[placemark locality], [placemark administrativeArea]]];
}

#pragma mark NSCoder delegate functions

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:title forKey:@"title"];
	[encoder encodeObject:subtitle forKey:@"subtitle"];
	[encoder encodeObject:location forKey:@"location"];
}

@end
