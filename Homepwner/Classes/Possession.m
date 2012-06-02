//
//  Possession.m
//  RandomPossessions
//
//  Created by Marc Mauger on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Possession.h"


@implementation Possession
@synthesize possessionName, serialNumber, valueInDollars, dateCreated, imageKey,
	inheritorName, inheritorNumber;

+ (id)randomPossession
{
	NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Dirty",
									@"Rotten",
									@"Crappy",
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
	[thumbnail release];
	[thumbnailData release];
	[possessionName release];
	[serialNumber release];
	[dateCreated release];
	[imageKey release];
	[inheritorName release];
	[inheritorNumber release];
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

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:possessionName forKey:@"possessionName"];
	[encoder encodeObject:serialNumber forKey:@"serialNumber"];
	[encoder encodeInt:valueInDollars forKey:@"valueInDollars"];
	[encoder encodeObject:dateCreated forKey:@"dateCreated"];
	[encoder encodeObject:imageKey forKey:@"imageKey"];
	[encoder encodeObject:thumbnailData forKey:@"thumbnailData"];
	[encoder encodeObject:inheritorName forKey:@"inheritorName"];
	[encoder encodeObject:inheritorNumber forKey:@"inheritorNumber"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	[super init];
	
	[self setPossessionName:[decoder decodeObjectForKey:@"possessionName"]];
	[self setSerialNumber:[decoder decodeObjectForKey:@"serialNumber"]];
	[self setValueInDollars:[decoder decodeIntForKey:@"valueInDollars"]];
	[self setImageKey:[decoder decodeObjectForKey:@"imageKey"]];
	// dateCreated is read only, we have no setter.  We explicitly
	// retain it and set our instance variable pointer to it
	dateCreated = [[decoder decodeObjectForKey:@"dateCreated"] retain];
	thumbnailData = [[decoder decodeObjectForKey:@"thumbnailData"] retain];
	
	[self setInheritorName:[decoder decodeObjectForKey:@"inheritorName"]];
	[self setInheritorNumber:[decoder decodeObjectForKey:@"inheritorNumber"]];
	
	return self;
}

- (UIImage *)thumbnail
{
	// Am I imageless?
	if (!thumbnailData) {
		return nil;
	}
	// Is there no cached thumbnail?
	if (!thumbnail) {
		// Create the image from the data
		thumbnail = [[UIImage imageWithData:thumbnailData] retain];
	}
	return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
	[thumbnailData release];
	[thumbnail release];
	
	CGRect imageRect = CGRectMake(0, 0, 70, 70);
	UIGraphicsBeginImageContext(imageRect.size);
	
	// Render the big image onto the image context
	[image drawInRect:imageRect];
	
	// Make a new one from the image context
	thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	
	// Retain the new one
	[thumbnail retain];
	
	// Clean up image context resources
	UIGraphicsEndImageContext();
	
	// Make a new data object from the image
	thumbnailData = UIImageJPEGRepresentation(thumbnail, 0.5);
	// You may get malloc warnings from the simulator.  Bug in simulator.
	
	[thumbnailData retain];
}

@end
