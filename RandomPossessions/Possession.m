//
//  Possession.m
//  RandomPossessions
//
//  Created by Marc Mauger on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Possession.h"


@implementation Possession
@synthesize possessionName, serialNumber, valueInDollars, dateCreated;

+ (id)randomPossession
{
	NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Dirty",
									@"Rotten",
									@"Slutty",
									nil];
	NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
							   @"Spork",
							   @"Mac", nil];
	
	int adjectiveIndex = random() % [randomAdjectiveList count];
	int nounIndex = random() % [randomNounList count];
	
	NSString *randomName = [NSString stringWithFormat:@"%@ %@",
							[randomAdjectiveList objectAtIndex:adjectiveIndex],
							[randomNounList objectAtIndex:nounIndex]];
	
	int randomValue = random() % 100;
	
	NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
									'0' + random() % 10,
									'A' + random() % 26,
									'0' + random() % 10,
									'A' + random() % 26,
									'0' + random() % 10];
									
									
	Possession *newPossession = 
	[[self alloc] initWithPossessionName:randomName
						  valueInDollars:randomValue
							serialNumber:randomSerialNumber];
	return [newPossession autorelease];
}


- (id)initWithPossessionName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
	self = [super init];
	if (!self)
		return nil;
	
	[self setPossessionName:name];
	[self setSerialNumber:sNumber];
	[self setValueInDollars:value];
	dateCreated = [[NSDate alloc] init];
	
	return self;
}

- (id)initWithPossessionName:(NSString *)name
{
	return [self initWithPossessionName:name
						 valueInDollars:0
						   serialNumber:@""];
}

- (id)init
{
	return [self initWithPossessionName:@"Possession"
						 valueInDollars:0
						   serialNumber:@""];
}

- (void)dealloc
{
	[possessionName release];
	[serialNumber release];
	[dateCreated release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ (%@): Worth $%d, Recorded on %@",
	 possessionName,
	 serialNumber,
	 valueInDollars,
	 dateCreated];

}
@end
