//
//  DepartmentViewController.m
//  Departments
//
//  Created by Marc Mauger on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DepartmentViewController.h"


@implementation DepartmentViewController

- (id)init
{
	if (![super initWithNibName:@"DepartmentView"
						 bundle:nil]) {
		return nil;
	}
	[self setTitle:@"Departments"];
	return self;
}

@end
