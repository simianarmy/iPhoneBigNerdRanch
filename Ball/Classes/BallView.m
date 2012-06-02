//
//  BallView.m
//  Ball
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 Simian Labs. All rights reserved.
//

#import "BallView.h"


@implementation BallView
@synthesize image;
@synthesize currentPoint;
@synthesize previousPoint;;
@synthesize acceleration;
@synthesize ballXVelocity;
@synthesize ballYVelocity;

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	if (self = [super initWithCoder:aDecoder]) {
		self.image = [UIImage imageNamed:@"ball.png"];
		self.currentPoint = CGPointMake((self.bounds.size.width / 2.0f) +
										(image.size.width / 2.0f), 
										(self.bounds.size.height / 2.0f) + (image.size.height / 2.0f));
		
		ballXVelocity = 0.0f;
		ballYVelocity = 0.0f;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	[image drawAtPoint:currentPoint];
}

- (void)dealloc {
	[image release];
	[acceleration release];
    [super dealloc];
}

#pragma mark -

- (CGPoint)currentPoint {
	return currentPoint;
}

- (void)setCurrentPoint:(CGPoint)newPoint {
	previousPoint = currentPoint;
	currentPoint = newPoint;
	
	if (currentPoint.x < 0) {
		currentPoint.x = 0;
		ballXVelocity = - (ballXVelocity / 2.0);
	}
	if (currentPoint.y < 0) {
		currentPoint.y = 0;
		ballYVelocity = - (ballYVelocity / 2.0);
	}
	if (currentPoint.x > self.bounds.size.width - image.size.width) {
		currentPoint.x = self.bounds.size.width - image.size.width;
		ballXVelocity = - (ballXVelocity / 2.0);
	}
	if (currentPoint.y > self.bounds.size.height - image.size.height) {
		currentPoint.y = self.bounds.size.height - image.size.height;
		ballYVelocity = - (ballYVelocity / 2.0);
	}
	
	CGRect currentImageRect = CGRectMake(currentPoint.x, currentPoint.y, 
										 currentPoint.x + image.size.width, 
										 currentPoint.y + image.size.height);
	CGRect previousImageRect = CGRectMake(previousPoint.x, previousPoint.y, 
										  previousPoint.x + image.size.width, 
										  previousPoint.y + image.size.height);
	[self setNeedsDisplayInRect:CGRectUnion(currentImageRect, previousImageRect)];
}

- (void)draw {
	static NSDate *lastDrawTime;
	
	if (lastDrawTime != nil) {
		NSTimeInterval secondsSinceLastDraw = 
		-([lastDrawTime timeIntervalSinceNow]);
		
		ballYVelocity = ballYVelocity + -(acceleration.y * secondsSinceLastDraw);
		ballXVelocity = ballXVelocity + acceleration.x * secondsSinceLastDraw;
		
		CGFloat xAcceleration = secondsSinceLastDraw * ballXVelocity * kVelocityMultiplier;
		CGFloat yAcceleration = secondsSinceLastDraw * ballYVelocity * kVelocityMultiplier;
		
		self.currentPoint = CGPointMake(self.currentPoint.x + xAcceleration, 
										self.currentPoint.y + yAcceleration);
	}
	// Update last time with current time
	[lastDrawTime release];
	lastDrawTime = [[NSDate alloc] init];
}


@end
