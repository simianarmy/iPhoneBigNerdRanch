//
//  FlipsideViewController.m
//  AppSettings
//
//  Created by Marc Mauger on 7/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "MainViewController.h"

@implementation FlipsideViewController

@synthesize delegate;
@synthesize engineSwitch;
@synthesize warpFactorSlider;

- (void)viewDidLoad {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	engineSwitch.on = ([[defaults objectForKey:kWarpDriveKey]
						isEqualToString:@"Engaged"]) ? YES : NO;
	warpFactorSlider.value = [defaults floatForKey:kWarpFactorKey];
	
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *prefValue = (engineSwitch.on) ? @"Engaged" : @"Disabled";
	[defaults setObject:prefValue forKey:kWarpDriveKey];
	[defaults setFloat:warpFactorSlider.value forKey:kWarpFactorKey];
	[super viewWillDisappear:animated];
}

- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.engineSwitch = nil;
	self.warpFactorSlider = nil;
	[super viewDidUnload];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	[engineSwitch release];
	[warpFactorSlider release];
    [super dealloc];
}


@end
