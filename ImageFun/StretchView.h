//
//  StretchView.h
//  ImageFun
//
//  Created by Marc Mauger on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface StretchView : NSView {
	NSBezierPath *path;
	NSImage *image;
	float opacity;
	NSPoint downPoint;
	NSPoint currentPoint;
	NSTimer* timer;
}
@property (readwrite) float opacity;
- (void)setImage:(NSImage *)newImage;
- (NSPoint)randomPoint;
- (NSRect)currentRect;

@end
