//
//  Foo.m
//  RandomApp
//
//  Created by Marc Mauger on 7/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Foo.h"


@implementation Foo
- (IBAction)generate:(id)sender
{
	int generated;
	generated = (random() % 100) + 1;
	
	NSLog(@"generated = %d", generated);
	[textField setIntValue:generated];
}

- (IBAction)seed:(id)sender
{
	srandom(time(NULL));
	[textField setStringValue:@"Generator seeded"];
}

- (void)awakeFromNib
{
	NSCalendarDate *now;
	now = [NSCalendarDate calendarDate];
	[textField setObjectValue:now];
}

@end
