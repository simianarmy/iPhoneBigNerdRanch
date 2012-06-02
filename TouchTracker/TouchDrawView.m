//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by Marc Mauger on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"
#import "Circle.h"

@implementation TouchDrawView

- (id)initWithCoder:(NSCoder *)c
{
	[super initWithCoder:c];
	completeLines = [NSKeyedUnarchiver 
					  unarchiveObjectWithFile:[self completedLinesPath]];
	if (!completeLines) {
		completeLines = [[NSMutableArray alloc] init];
	} else {
		[completeLines retain];
	}
	linesInProcess	= [[NSMutableDictionary alloc] init];
	completeCircles = [[NSMutableArray alloc] init];
	circlesInProcess = [[NSMutableDictionary alloc] init];
	[self setMultipleTouchEnabled:YES];
	return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 10.0);
	CGContextSetLineCap(context, kCGLineCapRound);
	
	// Draw complete lines in black
	[[UIColor blackColor] set];
	for (Line *line in completeLines) {
		CGContextMoveToPoint(context, [line begin].x, [line begin].y);
		CGContextAddLineToPoint(context, [line end].x, [line end].y);
		CGContextStrokePath(context);
	}
	// Draw complete circles in blue
	[[UIColor blueColor] set];
	for (Circle *c in completeCircles) {
		CGContextAddArc(context, CGRectGetMidX(c.frame),						
						CGRectGetMidY(c.frame),
						hypot(c.frame.size.width, c.frame.size.height) / 2.0, 
						0.0, M_PI * 2.0, YES);
		CGContextStrokePath(context);
	}
	// Draw lines in process in red 
	[[UIColor redColor] set];
	for (NSValue *v in linesInProcess) {
		Line *line = [linesInProcess objectForKey:v];
		CGContextMoveToPoint(context, [line begin].x, [line begin].y);
		CGContextAddLineToPoint(context, [line end].x, [line end].y);
		CGContextStrokePath(context);
	}
	// Draw complete circles in black
	for (NSValue *v in circlesInProcess) {
		Circle *c = [circlesInProcess objectForKey:v];
		CGContextAddArc(context, CGRectGetMidX(c.frame),						
						CGRectGetMidY(c.frame),
						hypot(c.frame.size.width, c.frame.size.height) / 2.0, 
						0.0, M_PI * 2.0, YES);
		CGContextStrokePath(context);
	}
}

- (NSMutableArray *)completedLines
{
	return completeLines;
}

- (void)clearAll
{
	// Clear the containers
	[linesInProcess removeAllObjects];
	[completeLines removeAllObjects];
	
	// Redraw
	[self setNeedsDisplay];
}

- (void)dealloc {
	[linesInProcess release];
	[completeLines release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches 
		   withEvent:(UIEvent *)event
{
	// Multi-touch is for circles?
	if ([touches count] > 1) {
		[self circleBegan:touches];
	} else {
		for (UITouch *t in touches) {
			// Is this a double tap?
			if ([t tapCount] > 1) {
				[self clearAll];
				return;
			}
			// Use the touch object as the key
			NSValue *key = [NSValue valueWithPointer:t];
			
			// Create a line for the value
			CGPoint loc = [t locationInView:self];
			Line *newLine = [[Line alloc] init];
			[newLine setBegin:loc];
			[newLine setEnd:loc];
			
			// Put pair in dictionary
			[linesInProcess setObject:newLine forKey:key];
			[newLine release];
		}
	}
}

// Handles multitouch for drawing circles
- (void)circleBegan:(NSSet *)touches
{
	// Get 1st 2 touches only
	UITouch *t1 = [[touches allObjects] objectAtIndex:0];
	UITouch *t2 = [[touches allObjects] objectAtIndex:1];
	CGPoint loc1 = [t1 locationInView:self];
	CGPoint loc2 = [t2 locationInView:self];
	
	// Use the 1st touch object as the key
	NSValue *key = [NSValue valueWithPointer:t1];
		
	// Create a circle for the value, using touch points as 
	// bounding box around the circle
	CGRect bb = CGRectMake(loc1.x, loc1.y, loc2.x - loc1.x, loc2.y - loc1.y);
	Circle *newCircle = [[Circle alloc] init];
	[newCircle setFrame:bb];
	
	[circlesInProcess setObject:newCircle forKey:key];
	[newCircle release];
}

- (void)touchesMoved:(NSSet *)touches
		   withEvent:(UIEvent *)event
{
	if ([touches count] > 1) {
		[self circleMoved:touches];
	} else {
		// Update linesInProcess with moved touches
		for (UITouch *t in touches) {
			NSValue *key = [NSValue valueWithPointer:t];
			
			// Fine the line for this touch
			Line *line = [linesInProcess objectForKey:key];
			
			// Update the line
			CGPoint loc = [t locationInView:self];
			[line setEnd:loc];
		}
	}
	// Redraw
	[self setNeedsDisplay];
}

- (void)circleMoved:(NSSet *)touches
{
	// Get 1st 2 touches only
	UITouch *t1 = [[touches allObjects] objectAtIndex:0];
	UITouch *t2 = [[touches allObjects] objectAtIndex:1];
	CGPoint loc1 = [t1 locationInView:self];
	CGPoint loc2 = [t2 locationInView:self];
	
	// Use the 1st touch object as the key
	NSValue *key = [NSValue valueWithPointer:t1];
	Circle *c = [circlesInProcess objectForKey:key];
	
	// Create a circle for the value, using touch points as 
	// bounding box around the circle
	CGRect bb = CGRectMake(loc1.x, loc1.y, loc2.x - loc1.x, loc2.y - loc1.y);
	[c setFrame:bb];
}

- (void)endTouches:(NSSet *)touches
{
	// Remove ending touches from dictionary
	if ([touches count] > 1) {
		[self circleEnded:touches];
	} else {
		for (UITouch *t in touches) {
			NSValue *key = [NSValue valueWithPointer:t];
			Line *line = [linesInProcess objectForKey:key];
			
			// If this is a double tap, 'line' will be nil
			if (line) {
				[completeLines addObject:line];
				[linesInProcess removeObjectForKey:key];
			}
		}
	}
	// Redraw
	[self setNeedsDisplay];
}

- (void)circleEnded:(NSSet *)touches
{
	// Use the 1st touch object as the key
	UITouch *t1 = [[touches allObjects] objectAtIndex:0];
	NSValue *key = [NSValue valueWithPointer:t1];
	Circle *c = [circlesInProcess objectForKey:key];
	
	if (c) {
		[completeCircles addObject:c];
		[circlesInProcess removeObjectForKey:key];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self endTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self endTouches:touches];
}

- (void)archiveLines
{
	// Archive lines to file
	[NSKeyedArchiver archiveRootObject:[self completedLines]
								toFile:[self completedLinesPath]];	
}

- (NSString *)completedLinesPath
{
	return pathInDocumentDirectory(@"lines.data");
}

@end
