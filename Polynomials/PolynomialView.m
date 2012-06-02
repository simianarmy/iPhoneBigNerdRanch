//
//  PolynomialView.m
//  Polynomials
//
//  Created by Marc Mauger on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PolynomialView.h"
#import "Polynomial.h"
#import <QuartzCore/QuartzCore.h>

#define MARGIN (10)

@implementation PolynomialView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        polynomials = [[NSMutableArray alloc] init];
		blasted = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
	NSRect bounds = [self bounds];
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect:bounds];
	
	/*
	// Get ahold of the core graphics context
	CGContextRef ctx = [[NSGraphicsContext currentContext]
						graphicsPort];
	// What is this?
	CGRect cgBounds = *(CGRect *)&bounds;
	
	// Draw the polynomials
	for (Polynomial *p in polynomials) {
		[p drawInRect:cgBounds inContext:ctx];
	}
	 */
}

- (IBAction)createNewPolynomial:(id)sender
{
	Polynomial *p = [[Polynomial alloc] init];
	[polynomials addObject:p];
	
	// Create a layer
	CALayer *layer = [CALayer layer];
	CGRect b = [[self layer] bounds];
	b = CGRectInset(b, MARGIN, MARGIN);
	[layer setAnchorPoint:CGPointMake(0,0)];
	[layer setFrame:b];
	[layer setCornerRadius:12];
	[layer setBorderColor:[p color]];
	[layer setBorderWidth:3.5];
	
	// The instance of the Polynomial will do the drawing
	[layer setDelegate:p];
	
	// Add the new layer to the base layer for the view
	[[self layer] addSublayer:layer];
	
	// Render the layer
	[layer display];
	
	// Make an animation that will move the layer on screen for 1 sec
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
	[anim setFromValue:
	 [NSValue valueWithPoint:[self randomOffViewPosition]]];
	[anim setToValue:
	 [NSValue valueWithPoint:NSMakePoint(MARGIN, MARGIN)]];
	[anim setDuration:1.0];
	CAMediaTimingFunction *f = 
	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[anim setTimingFunction:f];
	
	// Start the animation
	[layer addAnimation:anim forKey:@"whatever"];
}

- (IBAction)deleteRandomPolynomial:(id)sender
{
	// Get the array of CALayers that represent polynomials
	NSArray *polynomialLayers = [[self layer] sublayers];
	
	// None to remove?
	if ([polynomialLayers count] == 0) {
		NSBeep();
		return;
	}
	// Pick a random layer
	int i = random() % [polynomialLayers count];
	CALayer *layerToPull = [polynomialLayers objectAtIndex:i];
	
	// Choose a point to drag it off to
	NSPoint randPoint = [self randomOffViewPosition];
	
	// Create the animation that will drive the motion offscreen
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
	
	// The animation will let you stuff anything you want into its
	// dicitionary.  At end of animation, you want to know which layer was 
	// dragged.
	[anim setValue:layerToPull forKey:@"representedPolynomialLayer"];
	[anim setFromValue:
	 [NSValue valueWithPoint:NSMakePoint(MARGIN, MARGIN)]];
	[anim setToValue:
	 [NSValue valueWithPoint:randPoint]];
	[anim setDuration:1.0];
	CAMediaTimingFunction *f = 
	[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	[anim setTimingFunction:f];
	
	// You need a callback when the animation is done
	[anim setDelegate:self];
	[layerToPull addAnimation:anim forKey:@"whatever"];
	
	// The position during the animation is temporary.
	// Without the next line, the deleted polynomial flahses before
	// being removed.
	[layerToPull setPosition:CGPointMake(randPoint.x, randPoint.y)];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	CALayer *layerToPull =
	[anim valueForKey:@"representedPolynomialLayer"];
	Polynomial *p = [layerToPull delegate];
	[polynomials removeObjectIdenticalTo:p];
	[layerToPull removeFromSuperlayer];
}

- (IBAction)blastem:(id)sender
{
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:3.0];
	NSArray *polynomialLayers = [[self layer] sublayers];
	
	for (CALayer *layer in polynomialLayers) {
		CGPoint p;
		if (blasted) {
			p = CGPointMake(MARGIN, MARGIN);
		} else {
			NSPoint r = [self randomOffViewPosition];
			// Convert from NSPoint to CGPoint
			p = *(CGPoint *)&r;
		}
		[layer setPosition:p];
	}
	[NSAnimationContext endGrouping];
	blasted = !blasted;
}

- (NSPoint)randomOffViewPosition
{
	NSRect bounds = [self bounds];
	float radius = hypot(bounds.size.width, bounds.size.height);
	
	float angle = 2.0 * M_PI * (random() % 360 / 360.0);
	NSPoint p;
	p.x = radius * cos(angle);
	p.y = radius * sin(angle);
	return p;
}

- (void)resizeAndRedrawPolynomialLayers
{
	CGRect b = [[self layer] bounds];
	b = CGRectInset(b, MARGIN, MARGIN);
	
	NSArray *polynomialLayers = [[self layer] sublayers];
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0];
	for (CALayer *layer in polynomialLayers) {
		b.origin = [layer frame].origin;
		[layer setFrame:b];
		[layer setNeedsDisplay];
	}
	[NSAnimationContext endGrouping];
}

- (void)setFrameSize:(NSSize)newSize
{
	[super setFrameSize:newSize];
	if (![self inLiveResize]) {
		[self resizeAndRedrawPolynomialLayers];
	}
}

- (void)viewDidEndLiveResize
{
	[self resizeAndRedrawPolynomialLayers];
}
	
@end
