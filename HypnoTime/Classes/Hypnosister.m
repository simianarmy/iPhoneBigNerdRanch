//
//  Hypnosister.m
//  Hypnosister
//
//  Created by Marc Mauger on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Hypnosister.h"
#import "HypnoLayer.h"

@implementation Hypnosister
@synthesize xShift, yShift;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        stripeColor = [[UIColor lightGrayColor] retain];
    }
	boxLayer = [[CALayer alloc] init];
	[boxLayer setBounds:CGRectMake(0.0, 0.0, 85.0, 85.0)];
	[boxLayer setPosition:CGPointMake(160.0, 100.0)];
	// Make half-transparent red the background color for the layer
	UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
	// Get a CGColor object with the same color values
	CGColorRef cgReddish = [reddish CGColor];
	[boxLayer setBackgroundColor:cgReddish];
	
	UIImage *layerImage = [UIImage imageNamed:@"Hypno.png"];
	// Get the underlying CGImage
	CGImageRef image = [layerImage CGImage];
	
	// Put the CGImage on the layer
	[boxLayer setContents:(id)image];
	// Inset the image a bit on each side
	[boxLayer setContentsRect:CGRectMake(-0.1, -0.1, 1.2, 1.2)];
	// Let the image resize (without changing the aspect ratio)
	// to fill the contentRect
	[boxLayer setContentsGravity:kCAGravityResizeAspect];
	// Make hypnoLayer object the layer's drawing delegate
	hypnoLayer = [[HypnoLayer alloc] init];
	[boxLayer setDelegate:hypnoLayer];
	
	// Make it a sublayer of the view's layer
	[[self layer] addSublayer:boxLayer];
	
	// boxLayer is retained by its superlayer
	[boxLayer release];
	
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // What rectangle am I filling?
	CGRect bounds = [self bounds];
	
	CGPoint center;
	center.x = bounds.origin.x + bounds.size.width / 2.0;
	center.y = bounds.origin.y + bounds.size.height / 2.0;
	
	// From the center how far out to a corner?
	float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
	
	// Get the context being drawn upon
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// All lines will be drawn 10 points wide
	CGContextSetLineWidth(context, 10);
	
	[stripeColor setStroke];
	
	// Draw concentric circles from the outside in
	for (float currentRadius=maxRadius; currentRadius>0; currentRadius-=20) {
		center.x += xShift;
		center.y += yShift;
		CGContextAddArc(context, center.x, center.y,
						currentRadius, 0.0, M_PI * 2.0, YES);
		[[self randomColor] setStroke];
		CGContextStrokePath(context);
	}
	// Create a string
	NSString *text  = @"You are getting sleepy.";
	
	// Get a font to draw it in
	UIFont *font = [UIFont boldSystemFontOfSize:28];
	
	// Where to draw it?
	CGRect textRect;
	textRect.size = [text sizeWithFont:font];
	textRect.origin.x = center.x - textRect.size.width / 2.0;
	textRect.origin.y = center.y - textRect.size.height / 2.0;
	
	// Set the fill color
	[[UIColor blackColor] setFill];
	
	// Set the shadow
	CGSize offset = CGSizeMake(4, 3);
	CGColorRef color = [[UIColor darkGrayColor] CGColor];
	CGContextSetShadowWithColor(context, offset, 2.0, color);
	
	// Draw the string
	[text drawInRect:textRect withFont:font];
}

- (void)dealloc {
	[stripeColor release];
	[hypnoLayer release];
    [super dealloc];
}

- (UIColor *)randomColor
{
	float rgb[3];
	// Generate random color
	rgb[0] = random() % 256 / 256.0;
	rgb[1] = random() % 256 / 256.0;
	rgb[2] = random() % 256 / 256.0;
	
	// needs autorelease?
	return [UIColor colorWithRed:rgb[0]
						green:rgb[1]
						blue:rgb[2]
						alpha:1];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	// Shake is the only kind of motion for now
	if (motion == UIEventSubtypeMotionShake) {
		NSLog(@"shake started");
		float r, g, b;
		r = random() % 256 / 256.0;
		g = random() % 256 / 256.0;
		b = random() % 256 / 256.0;
		[stripeColor release];
		stripeColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
		[stripeColor retain];
		[self setNeedsDisplay];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *t = [touches anyObject];
	CGPoint p = [t locationInView:self];
	[boxLayer setPosition:p];
	
	[hypnoLayer setViewFrame:[self frame]];
	[hypnoLayer setSuperLayerY:p.y];
	[boxLayer setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *t = [touches anyObject];
	CGPoint p = [t locationInView:self];
	[hypnoLayer setViewFrame:[self frame]];
	[hypnoLayer setSuperLayerY:p.y];
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithBool:YES]
					 forKey:kCATransactionDisableActions];
	[boxLayer setPosition:p];
	[CATransaction commit];
	[boxLayer setNeedsDisplay];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}
		
@end
