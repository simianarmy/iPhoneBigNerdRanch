//
//  MapPoint.m
//  Whereami
//
//  Created by Marc Mauger on 11/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"


@implementation MapPoint
@synthesize coordinate, title, subtitle;


- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
	[super init];
	coordinate = c;
	[self setTitle:t];
	[self setSubtitle:@""];
	
	return self;
}

- (void)dealloc
{
	NSLog(@"Releasing MapPoint");
	[title release];
	[subtitle release];
	[super dealloc];
}


@end
