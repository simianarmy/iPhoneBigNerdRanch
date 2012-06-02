//
//  PinchMeViewController.m
//  PinchMe
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 Simian Labs. All rights reserved.
//

#import "PinchMeViewController.h"
#import "CGPointUtils.h"

@implementation PinchMeViewController
@synthesize label;
@synthesize initialDistance;

- (void)eraseLabel {
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
	if ([touches count] == 2) {
		NSArray *twoTouches = [touches allObjects];
		UITouch *first = [twoTouches objectAtIndex:0];
		UITouch *second = [twoTouches objectAtIndex:1];
		initialDistance = distanceBetweenPoints(
												[first locationInView:self.view],
												[second locationInView:self.view]);
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches count] == 2) {
		NSArray *twoTouches = [touches allObjects];
		UITouch *first = [twoTouches objectAtIndex:0];
		UITouch *second = [twoTouches objectAtIndex:1];
		CGFloat currentDistance = distanceBetweenPoints(
												[first locationInView:self.view],
												[second locationInView:self.view]);

		if (initialDistance == 0)
			initialDistance = currentDistance;
		else if (currentDistance - initialDistance > kMinimumPinchDelta) {
			label.text = @"Outward Pinche";
			[self performSelector:@selector(eraseLabel)
					   withObject:nil
					   afterDelay:1.6f];
		}
		else if (initialDistance - currentDistance > kMinimumPinchDelta) {
			label.text = @"Inward Pinch";
			[self performSelector:@selector(eraseLabel)
					   withObject:nil
					   afterDelay:1.6f];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	initialDistance = 0;
}

@end
