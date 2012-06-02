//
//  GLFunViewController.m
//  GLFun
//
//  Created by Marc Mauger on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GLFunViewController.h"
#import "Constants.h"
#import "GLFunView.h"
#import "UIColor-Random.h"

@implementation GLFunViewController
@synthesize colorControl;

- (IBAction)changeColor:(id)sender {
	UISegmentedControl *control = sender;
	NSInteger index = [control selectedSegmentIndex];
	
	GLFunView *glView = (GLFunView *)self.view;
	
	switch (index) {
		case kRedColorTab:
			glView.currentColor = [UIColor redColor];
			glView.useRandomColor = NO;
			break;
		case kBlueColorTab:
			glView.currentColor = [UIColor blueColor];
			glView.useRandomColor = NO;
			break;
		case kYellowColorTab:
			glView.currentColor = [UIColor yellowColor];
			glView.useRandomColor = NO;
			break;
		case kGreenColorTab:
			glView.currentColor = [UIColor greenColor];
			glView.useRandomColor = NO;
			break;
		case kRandomColorTab:
			glView.useRandomColor = YES;
			break;
		default:
			break;
	}
}

- (IBAction)changeShape:(id)sender {
	UISegmentedControl *control = sender;
	[(GLFunView  *)self.view setShapeType:[control
											  selectedSegmentIndex]];
	
	if ([control selectedSegmentIndex] == kImageShape)
		colorControl.hidden = YES;
	else
		colorControl.hidden = NO;
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
	self.colorControl = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[colorControl release];
    [super dealloc];
}

@end
