//
//  StretchView.h
//  ImageFun
//
//  Created by Marc Mauger on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface StretchView : NSView {
	NSBezierPath *path, *currentPath;
	NSPoint downPoint;
	NSPoint currentPoint;
}
- (NSRect)currentRect;
- (BOOL)isPointEqual:(NSPoint)p1
				  to:(NSPoint)p2;

@end
