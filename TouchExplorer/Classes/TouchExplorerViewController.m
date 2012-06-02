//
//  TouchExplorerViewController.m
//  TouchExplorer
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchExplorerViewController.h"

@implementation TouchExplorerViewController
@synthesize messageLabel;
@synthesize tapsLabel;
@synthesize touchesLabel;

- (void)updateLabelsFromTouches:(NSSet *)touches {
	NSUInteger numTaps = [[touches anyObject] tapCount];
	NSString *tapsMessage = [[NSString alloc]
							 initWithFormat:@"%d taps detected", numTaps];
	tapsLabel.text = tapsMessage;
	[tapsMessage release];
	
	NSUInteger numTouches = [touches count];
	NSString *touchMsg = [[NSString alloc] initWithFormat:
						  @"%d touches detected", numTouches];
	touchesLabel.text = touchMsg;
	[touchMsg release];
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
	self.messageLabel = nil;
	self.tapsLabel = nil;
	self.touchesLabel = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[messageLabel release];
	[tapsLabel release];
	[touchesLabel release];
    [super dealloc];
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	messageLabel.text = @"Touches Began";
	[self updateLabelsFromTouches:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	messageLabel.text = @"Touches Cancelled";
	[self updateLabelsFromTouches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	messageLabel.text = @"Touches Stopped.";
	[self updateLabelsFromTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	messageLabel.text = @"Drag Detected";
	[self updateLabelsFromTouches:touches];
}

@end
