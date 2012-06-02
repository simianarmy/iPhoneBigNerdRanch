//
//  StretchView.m
//  ImageFun
//
//  Created by Marc Mauger on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StretchView.h"


@implementation StretchView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
	srandom(time(NULL));
	
	// Create a path object
	path = [[NSBezierPath alloc] init];
	[path setLineWidth:3.0];
	return self;
}

- (void)drawRect:(NSRect)rect {
	NSRect bounds = [self bounds];
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect:bounds];
	
    	// Draw the path in white
	[[NSColor blackColor] set];
	[path stroke];
	
	if (![self isPointEqual:currentPoint to:downPoint]) {
		[[NSBezierPath bezierPathWithOvalInRect:[self currentRect]] stroke];
	}
}

- (NSRect)currentRect
{
	float minX = MIN(downPoint.x, currentPoint.x);
	float maxX = MAX(downPoint.x, currentPoint.x);
	float minY = MIN(downPoint.y, currentPoint.y);
	float maxY = MAX(downPoint.y, currentPoint.y);
	
	return NSMakeRect(minX, minY, maxX-minX, maxY-minY);
}

- (BOOL)isPointEqual:(NSPoint)p1
				  to:(NSPoint)p2
{
	return (p1.x == p2.x) && (p1.y == p2.y);
}

- (void)dealloc
{
	[path release];
	
	[super dealloc];
}


#pragma mark Events

- (void)mouseDown:(NSEvent *)event
{
	NSPoint p = [event locationInWindow];
	downPoint = [self convertPoint:p fromView:nil];
	currentPoint = downPoint;
	NSLog(@"mouseDown at %@", NSStringFromPoint(currentPoint));
	[self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint p = [theEvent locationInWindow];
	currentPoint = [self convertPoint:p fromView:nil];
	
	NSLog(@"mouseDragged to %@", NSStringFromPoint(currentPoint));
		
	[self autoscroll:theEvent];
	[self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	NSPoint p = [theEvent locationInWindow];
	currentPoint = [self convertPoint:p fromView:nil];
	
	[path appendBezierPathWithOvalInRect:[self currentRect]];
	[self setNeedsDisplay:YES];
}

#pragma mark Accessors


@end
