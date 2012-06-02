//
//  StretchView.m
//  ImageFun
//
//  Created by Marc Mauger on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StretchView.h"

@interface StretchView ()
- (void)doAutoScroll:(NSTimer *)aTimer;
@end

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
	
	NSPoint p = [self randomPoint];
	
	[path moveToPoint:p];
	int i;
	for (i=0; i<15; i++) {
		p = [self randomPoint];
		
		[path curveToPoint:p 
			 controlPoint1:[self randomPoint]
			 controlPoint2:[self randomPoint]];
	}
	[path closePath];
	opacity = 1.0;
	
    return self;
}

- (void)drawRect:(NSRect)rect {
    NSRect bounds = [self bounds];
	[[NSColor greenColor] set];
	[NSBezierPath fillRect:bounds];
	
	// Draw the path in white
	[[NSColor whiteColor] set];
	[path fill];
	
	if (image) {
		NSRect imageRect;
		imageRect.origin = NSZeroPoint;
		imageRect.size = [image size];
		NSRect drawingRect = [self currentRect];
		[image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:opacity];
	}		 
}

- (void)dealloc
{
	[path release];
	[image release];
	[super dealloc];
}

- (NSPoint)randomPoint
{
	NSPoint result;
	NSRect r = [self bounds];
	result.x = r.origin.x + random() % (int)r.size.width;
	result.y = r.origin.y + random() % (int)r.size.height;
	return result;
}

- (NSRect)currentRect
{
	float minX = MIN(downPoint.x, currentPoint.x);
	float maxX = MAX(downPoint.x, currentPoint.x);
	float minY = MIN(downPoint.y, currentPoint.y);
	float maxY = MAX(downPoint.y, currentPoint.y);
	
	return NSMakeRect(minX, minY, maxX-minX, maxY-minY);
}

#pragma mark Events

- (void)mouseDown:(NSEvent *)event
{
	NSPoint p = [event locationInWindow];
	downPoint = [self convertPoint:p fromView:nil];
	currentPoint = downPoint;
	if (timer == nil) {
		timer = [[NSTimer scheduledTimerWithTimeInterval:0.1 
												  target:self
												  selector:@selector(doAutoScroll:)
												userInfo:nil
												 repeats:YES] retain];
	} else {
		NSLog(@"Timer already exists on mouseDown");
	}
	[self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint p = [theEvent locationInWindow];
	currentPoint = [self convertPoint:p fromView:nil];
	
	[self setNeedsDisplay:YES];
}


- (void)mouseUp:(NSEvent *)theEvent
{
	NSPoint p = [theEvent locationInWindow];
	currentPoint = [self convertPoint:p fromView:nil];
	if (timer) {
		[timer invalidate];
		[timer release];
		timer = nil;
	}
	[self setNeedsDisplay:YES];
}

- (void)doAutoScroll:(NSTimer *)aTimer
{
	NSEvent *e = [NSApp currentEvent];
	[self autoscroll:e];
}

#pragma mark Accessors

- (void)setImage:(NSImage *)newImage
{
	[newImage retain];
	[image release];
	image = newImage;
	NSSize imageSize = [newImage size];
	downPoint = NSZeroPoint;
	currentPoint.x = downPoint.x + imageSize.width;
	currentPoint.y = downPoint.y + imageSize.height;
	[self setNeedsDisplay:YES];
}

- (float)opacity
{
	return opacity;
}

- (void)setOpacity:(float)x
{
	opacity = x;
	[self setNeedsDisplay:YES];
}

// Unused
- (NSPoint)jitterPoint:(NSPoint)p
{
	NSPoint res;
	res.x = p.x / 2;
	res.y = p.y / 2;
	return res;
}

@end
