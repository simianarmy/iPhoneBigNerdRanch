//
//  CarArrayController.m
//  CarLot
//
//  Created by Marc Mauger on 9/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CarArrayController.h"


@implementation CarArrayController

- (id)newObject
{
	id newObj = [super newObject];
	NSDate *now = [NSDate date];
	[newObj setValue:now forKey:@"datePurchased"];
	return newObj;
}

@end
