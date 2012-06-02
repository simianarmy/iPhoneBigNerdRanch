//
//  ManagingViewController.m
//  Departments
//
//  Created by Marc Mauger on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ManagingViewController.h"


@implementation ManagingViewController
@synthesize managedObjectContext;

- (void)dealloc
{
	[managedObjectContext release];
	[super dealloc];
}
@end
