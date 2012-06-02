//
//  AppController.m
//  KVCFun
//
//  Created by Marc Mauger on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController
- (id)init
{
	[super init];
	[self setValue:[NSNumber numberWithInt:5]
			forKey:@"fido"];
	NSNumber *n = [self valueForKey:@"fido"];
	NSLog(@"fido = %@", n);
	return self;
}

- (int)fido
{
	NSLog(@"-fido is returning %d", fido);
	return fido;
}

- (void)setFido:(int)x
{
	NSLog(@"-setFido: is called with %d", x);
	fido = x;
}

- (IBAction)incrementFido:(id)sender
{
	[self setFido:[self fido] + 1];
	NSLog(@"fido is now %d", fido);
}
@end
