    //
//  HypnosisViewController.m
//  HypnoTime
//
//  Created by Marc Mauger on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HypnosisViewController.h"
#import "Hypnosister.h"

@implementation HypnosisViewController

- (id)init
{
	[super initWithNibName:nil bundle:nil];
	
	// Get the tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle:@"Hypno"];
	
	// Create a UIIMage from a file
	UIImage *i = [UIImage imageNamed:@"Hypno.png"];
	
	// Put that image on the tab item
	[tbi setImage:i];
	
	return self;
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	return [self init];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSLog(@"Monitoring accelerometer");
	UIAccelerometer *a = [UIAccelerometer sharedAccelerometer];
	// Receive updates every 1/10th of a second
	[a setUpdateInterval:0.1];
	[a setDelegate:self];
	
	[[self view] becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)dealloc {
    [super dealloc];
}

- (void)loadView
{
	Hypnosister *hv = [[Hypnosister alloc] initWithFrame:CGRectZero];
	[hv setBackgroundColor:[UIColor whiteColor]];
	[self setView:hv];
	[hv release];
}

# pragma mark UIAccelerometerDelegate functions

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)accel
{
	NSLog(@"%f, %f, %f", [accel x], [accel y], [accel z]);
	Hypnosister *hv = (Hypnosister *)[self view];
	[hv setXShift:10.0 * [accel x]];
	[hv setYShift:-10.0 * [accel y]];
	
	// Redraw the view
	[hv setNeedsDisplay];
}

@end
