//
//  Polynomial.h
//  Polynomials
//
//  Created by Marc Mauger on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Polynomial : NSObject {
	__strong CGFloat *terms;
	int termCount;
	__strong CGColorRef color;
}
- (float)valueAt:(float)x;
- (void)drawInRect:(CGRect)b
		 inContext:(CGContextRef)ctx;
- (CGColorRef)color;

@end
