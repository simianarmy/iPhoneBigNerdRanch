//
//  President.h
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define kPresidentNumberKey	@"President"
#define kPresidentNameKey	@"Name"
#define kPresidentFromKey	@"FromYear"
#define kPresidentToKey		@"ToYear"
#define kPresidentPartyKey	@"Party"

#import <Foundation/Foundation.h>


@interface President : NSObject <NSCoding> {
	int			number;
	NSString	*name;
	NSString	*fromYear;
	NSString	*toYear;
	NSString	*party;
}
@property int number;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fromYear;
@property (nonatomic, retain) NSString *toYear;
@property (nonatomic, retain) NSString *party;

@end
