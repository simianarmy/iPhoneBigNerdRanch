//
//  CurrentTimeViewController.m
//  HypnoTime
//
//  Created by Marc Mauger on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CurrentTimeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CurrentTimeViewController
@synthesize timeButton;

- (id)init
{
	[super initWithNibName:@"CurrentTimeViewController" bundle:nil];
	
	// Get the tab bar item
	UITabBarItem *tbi = [self tabBarItem];
	
	// Give it a label
	[tbi setTitle:@"Time"];

	// Create a UIIMage from a file
	UIImage *i = [UIImage imageNamed:@"Time.png"];
	
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
	NSLog(@"Must have received a low memory warning..");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[timeLabel release];
	timeLabel = nil;
	[timeButton release];
	timeButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self showCurrentTime:nil];
	[self slideInButton];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)dealloc {
	[timeLabel release];
	[timeButton release];
    [super dealloc];
}

- (IBAction)showCurrentTime:(id)sender
{
	NSDate *now = [NSDate date];
	
	static NSDateFormatter *formatter = nil;
	if (!formatter) {
		formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeStyle:NSDateFormatterMediumStyle];
	}
	[timeLabel setText:[formatter stringFromDate:now]];
	
	// Create a key frame animation
	CAKeyframeAnimation *bounce = 
	[CAKeyframeAnimation animationWithKeyPath:@"transform"];
	
	// Create the values it will pass through
	CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
	CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
	CATransform3D forward2 = CATransform3DMakeScale(1.2, 1.2, 1);
	CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
	[bounce setValues:[NSArray arrayWithObjects:
					   [NSValue valueWithCATransform3D:CATransform3DIdentity],
					   [NSValue valueWithCATransform3D:forward],
					   [NSValue valueWithCATransform3D:back],
					   [NSValue valueWithCATransform3D:forward2],
					   [NSValue valueWithCATransform3D:back2],
					   [NSValue valueWithCATransform3D:CATransform3DIdentity],
					   nil]];
	// Set the duration
	[bounce setDuration:0.6];
	
	// Animate the layer
	[[timeLabel layer] addAnimation:bounce forKey:@"bounceAnimation"];
	
	// Create fader animation
	CAKeyframeAnimation *fader = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
	NSArray *vals = [NSMutableArray array];
	[vals addObject:[NSNumber numberWithFloat:0.5]];
	[vals addObject:[NSNumber numberWithFloat:1.0]];
	[vals addObject:[NSNumber numberWithFloat:0.1]];
	[vals addObject:[NSNumber numberWithFloat:1.0]];
	[vals addObject:[NSNumber numberWithFloat:0.1]];
	[vals addObject:[NSNumber numberWithFloat:0.5]];
	[fader setValues:vals];
	[fader setDuration:0.6];
	[[timeLabel layer] addAnimation:fader forKey:@"fadeAnimation"];
	
/*	
	// Create a basic animation
	CABasicAnimation *spin =
	[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	
	// fromValue is implied
	[spin setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
	[spin setDuration:1.0];
	
	// Set the timing function
	CAMediaTimingFunction *tf = [CAMediaTimingFunction
								 functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[spin setTimingFunction:tf];
	
	[spin setDelegate:self];
	
	// Kick off the animation by adding it to the layer
	[[timeLabel layer] addAnimation:spin forKey:@"spinAnimation"];
*/	
}

- (void)slideInButton
{
	// Slide button into view ...supposedly this view is supposed to slide
	// into view...seems instant to me?!
	// Just pick random direction (left or right).
	if (timeButton) {
		float fromX = ((random()%2) == 0 ? 0.0 : [timeLabel frame].size.width);
		CABasicAnimation *slider = [CABasicAnimation animationWithKeyPath:@"position"];
		CGPoint viewCenter = [timeButton center];
		[slider setDuration:1.0];
		[slider setFromValue:[NSValue valueWithCGPoint:CGPointMake(fromX, viewCenter.y)]];
		[slider setToValue:[NSValue valueWithCGPoint:viewCenter]];
		// Set the timing function
		CAMediaTimingFunction *tf = [CAMediaTimingFunction
									 functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		[slider setTimingFunction:tf];
		
		[[timeButton layer] addAnimation:slider forKey:@"slideAnimation"];
		[[timeButton layer] setPosition:viewCenter];
	} else {
		NSLog(@"timeButton NIL!?");
	}
	
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	NSLog(@"%@ finished: %d", anim, flag);
}

@end
