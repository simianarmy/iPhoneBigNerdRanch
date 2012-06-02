//
//  HypnoTimeAppDelegate.m
//  HypnoTime
//
//  Created by Marc Mauger on 12/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HypnoTimeAppDelegate.h"
#import "HypnosisViewController.h"
#import "CurrentTimeViewController.h"
#import "MapViewController.h"

@implementation HypnoTimeAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	// Create the tabBarController
	UITabBarController *tabBarController = [[UITabBarController alloc] init];

	// Create the 2 view controllers
	UIViewController *vc1 = [[HypnosisViewController alloc] init];
	UIViewController *vc2 = [[CurrentTimeViewController alloc] init];
	UIViewController *vc3 = [[MapViewController alloc] init];
	
	NSArray *viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, nil];
	[vc1 release];
	[vc2 release];
	[vc3 release];
	
	// Attach them to the tab bar controller
	[tabBarController setViewControllers:viewControllers animated:YES];
	
	// Set it a rootViewController of window
	// IOS < 4.2 code
	// [window addSubview:[tabBarController view]];
	[window setRootViewController:tabBarController];
	[tabBarController release];
	
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)dealloc {
	[window release];
    [super dealloc];
}


@end
