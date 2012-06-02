//
//  Possession.h
//  RandomPossessions
//
//  Created by Marc Mauger on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Possession : NSObject {
	NSString *possessionName;
	NSString *serialNumber;
	int valueInDollars;
	NSDate *dateCreated;
}
@property (nonatomic, copy) NSString *possessionName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;

+ (id)randomPossession;

- (id)initWithPossessionName:(NSString *)name
			  valueInDollars:(int)value
				serialNumber:(NSString *)sNumber;

- (id)initWithPossessionName:(NSString *)name;
@end
