//
//  FirstLetter.m
//  TypingTutor
//
//  Created by Marc Mauger on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FirstLetter.h"


@implementation NSString (FirstLetter)

- (NSString *)BNR_firstLetter
{
	if ([self length] < 2) {
		return self;
	}
	NSRange r;
	r.location = 0;
	r.length = 1;
	return [self substringWithRange:r];
}

@end
