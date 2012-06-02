//
//  PolynomialView.h
//  Polynomials
//
//  Created by Marc Mauger on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PolynomialView : NSView {
	NSMutableArray *polynomials;
	BOOL blasted;
}
- (IBAction)createNewPolynomial:(id)sender;
- (IBAction)deleteRandomPolynomial:(id)sender;
- (IBAction)blastem:(id)sender;
- (NSPoint)randomOffViewPosition;

@end
