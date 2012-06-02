//
//  Line.m
//  TouchTracker
//
//  Created by Marc Mauger on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Line.h"


@implementation Line
@synthesize begin, end;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSValue *dBegin = [aDecoder decodeObjectForKey:@"begin"];
	[dBegin getValue:&begin];
	NSValue *dEnd = [aDecoder decodeObjectForKey:@"end"];
	[dEnd getValue:&end];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	NSValue *beginVal = [NSValue value:&begin withObjCType:@encode(CGPoint)];
	[encoder encodeObject:beginVal forKey:@"begin"];
	NSValue *endVal = [NSValue value:&end withObjCType:@encode(CGPoint)];
	[encoder encodeObject:endVal forKey:@"end"];
}

@end
