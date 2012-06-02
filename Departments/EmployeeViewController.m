//
//  EmployeeViewController.m
//  Departments
//
//  Created by Marc Mauger on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmployeeViewController.h"


@implementation EmployeeViewController
- (id)init
{
	if (![super initWithNibName:@"EmployeeView"
						 bundle:nil]) {
		return nil;
	}
	[self setTitle:@"Employees"];
	return self;
}

@end
