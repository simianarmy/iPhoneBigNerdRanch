//
//  PersistenceAppDelegate.m
//  Persistence
//
//  Created by Marc Mauger on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PersistenceAppDelegate.h"
#import "PersistenceViewController.h"

@implementation PersistenceAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
