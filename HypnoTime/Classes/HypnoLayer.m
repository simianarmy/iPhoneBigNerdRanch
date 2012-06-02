//
//  HypnoLayer.m
//  HypnoTime
//
//  Created by Marc Mauger on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HypnoLayer.h"


@implementation HypnoLayer
@synthesize superLayerY, viewFrame;

- (id)init
{
	self = [super init];
	if (self) {
		viewFrame = CGRectZero;
	}
	return self;
}

- (void)drawLayer:(CALayer *)alayer inContext:(CGContextRef)ctx
{
	UIImage *layerImage = [UIImage imageNamed:@"Hypno.png"];
	CGRect boundingBox = CGContextGetClipBoundingBox(ctx);
	// layer setOpacity doesn't work - always sets it = 0 ??
	// Must set background and image alphas manually...
	CGContextSetAlpha(ctx, [self getBoxOpacity]);
	/*
	UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:opacity];
	// Get a CGColor object with the same color values
	CGColorRef cgReddish = [reddish CGColor];
	[alayer setBackgroundColor:cgReddish];
	*/
	CGContextDrawImage(ctx, boundingBox, [layerImage CGImage]);
}

// Returns desired opacity based on position of layer relative to 
// parent layer's top.
- (float)getBoxOpacity
{
	float ydiff = viewFrame.size.height - superLayerY;
	//NSLog(@"ydiff = %f", ydiff);
	return (float)(ydiff / viewFrame.size.height);
}
	
@end
