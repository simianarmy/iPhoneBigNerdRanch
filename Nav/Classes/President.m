//
//  President.m
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "President.h"


@implementation President
@synthesize number;
@synthesize name;
@synthesize fromYear;
@synthesize toYear;
@synthesize party;

- (void)dealloc {
	[name release];
	[fromYear release];
	[toYear release];
	[party release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeInt:self.number forKey:kPresidentNumberKey];
	[coder encodeObject:self.name forKey:kPresidentNameKey];
	[coder encodeObject:self.fromYear forKey:kPresidentFromKey];
	[coder encodeObject:self.toYear forKey:kPresidentToKey];
	[coder encodeObject:self.party forKey:kPresidentPartyKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		self.number = [aDecoder decodeIntForKey:kPresidentNumberKey];
		self.name = [aDecoder decodeObjectForKey:kPresidentNameKey];
		self.fromYear = [aDecoder decodeObjectForKey:kPresidentFromKey];
		self.toYear = [aDecoder decodeObjectForKey:kPresidentToKey];
		self.party = [aDecoder decodeObjectForKey:kPresidentPartyKey];
	}
	return self;
}

@end
