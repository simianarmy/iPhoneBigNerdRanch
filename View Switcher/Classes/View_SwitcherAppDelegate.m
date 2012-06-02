//
//  View_SwitcherAppDelegate.m
//  View Switcher
//
//  Created by Marc Mauger on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "View_SwitcherAppDelegate.h"
#import "SwitchViewController.h"

@implementation View_SwitcherAppDelegate

@synthesize window;
@synthesize switchViewController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:switchViewController.view];
	[window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
	[switchViewController release];
    [super dealloc];
}


@end
