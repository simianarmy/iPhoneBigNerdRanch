// 
//  Employee.m
//  Departments
//
//  Created by Marc Mauger on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Employee.h"


@implementation Employee 

@dynamic firstName;
@dynamic lastName;
@dynamic department;

- (NSString *)fullName
{
	NSString *first = [self firstName];
	NSString *last = [self lastName];
	if (!first)
		return last;
	if (!last)
		return first;
	
	return [NSString stringWithFormat:@"%@ %@", first, last];
}

+ (NSSet *)keyPathsForValuesAffectingFullName
{
	return [NSSet setWithObjects:@"firstName", @"lastName", nil];
}

@end
