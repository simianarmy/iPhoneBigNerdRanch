//
//  SwipesViewController.m
//  Swipes
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SwipesViewController.h"

@implementation SwipesViewController
@synthesize label;
@synthesize gestureStartPoint;

- (void)eraseText {
	label.text = @"";
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.label = nil;
}


- (void)dealloc {
	[label release];
    [super dealloc];
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch  = [touches anyObject];
	gestureStartPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	SwipeType swipeType = kNoSwipe;
	for (UITouch *touch in touches) {
		CGPoint currentPosition = [touch locationInView:self.view];
		
		CGFloat deltaX = fabsf(currentPosition.x - gestureStartPoint.x);
		CGFloat deltaY = fabsf(currentPosition.y - gestureStartPoint.y);
		
		if (deltaX >= kMinimumGestureLength &&
			deltaY <= kMaximumVariance)
			swipeType = kHorizontalSwipe;
		else if (deltaY >= kMinimumGestureLength &&
				 deltaX <= kMaximumVariance)
			swipeType = kVerticalSwipe;
	}
	BOOL allFingersFarEnoughAway = YES;
	if (swipeType != kNoSwipe) {
		for (UITouch *touch in touches) {
			CGPoint currentPosition = [touch locationInView:self.view];
			
			CGFloat distance;
			if (swipeType == kHorizontalSwipe)
				distance = fabsf(currentPosition.x - gestureStartPoint.x);
			else
				distance = fabsf(currentPosition.y - gestureStartPoint.y);
			
			if (distance < kMinimumGestureLength)
				allFingersFarEnoughAway = NO;
		}
	}
	if (allFingersFarEnoughAway && swipeType != kNoSwipe) {
		NSString *swipeCountString = nil;
		if ([touches count] > 1) 
			swipeCountString = [[NSString alloc] initWithFormat:@"%d", [touches count]];
		else
			swipeCountString = @"";
		
		NSString *swipeTypeString = (swipeType == kHorizontalSwipe) ? 
		@"Horizontal" : @"Vertical";
		
		NSString *message = [[NSString alloc] initWithFormat:
							 @"%@%@ Swipe detected.", swipeCountString, swipeTypeString];
		label.text = message;
		[swipeCountString release];
		[message release];
		[self performSelector:@selector(eraseText)
				   withObject:nil afterDelay:2];
	}
}
@end
