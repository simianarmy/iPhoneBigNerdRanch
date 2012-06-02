//
//  LotteryEntry.m
//  lottery
//
//  Created by Marc Mauger on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LotteryEntry.h"


@implementation LotteryEntry

- (id)init
{
	return [self initWithEntryDate:[NSCalendarDate calendarDate]];
}
			
- (id)initWithEntryDate:(NSCalendarDate *)theDate
{
	[super init];
	
	NSAssert(theDate != nil, @"Argument can't be nil, dog");
	entryDate = theDate;
	firstNumber = random() % 100 + 1;
	secondNumber = random() % 100 + 1;
	return self;
}

- (void)setEntryDate:(NSCalendarDate *)date
{
	entryDate = date;
}

- (NSCalendarDate *)entryDate
{
	return entryDate;
}

- (int)firstNumber
{
	return firstNumber;
}

- (int)secondNumber
{
	return secondNumber;
}

- (NSString *)description
{
	NSString *result;
	result = [[NSString alloc] initWithFormat:@"%@ = %d and %d",
			  [entryDate descriptionWithCalendarFormat:@"%c"],
			  firstNumber, secondNumber];
	return result;
}
@end
