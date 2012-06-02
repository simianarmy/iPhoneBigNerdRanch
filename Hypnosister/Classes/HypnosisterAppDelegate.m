//
//  HypnosisterAppDelegate.m
//  Hypnosister
//
//  Created by Marc Mauger on 12/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HypnosisterAppDelegate.h"
#import "Hypnosister.h"

@implementation HypnosisterAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	CGRect wholeWindow = [window bounds];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:wholeWindow];
	[window addSubview:scrollView];
	[scrollView release];
	
	// Make view twice as large as window
	CGRect bigRect;
	bigRect.origin = CGPointZero;
	bigRect.size.width = wholeWindow.size.width * 2.0;
	bigRect.size.height = wholeWindow.size.height * 2.0;
	[scrollView setContentSize:bigRect.size];
	
	// Center it in the scroll view
	CGPoint offset;
	offset.x = wholeWindow.size.width * 0.5;
	offset.y = wholeWindow.size.height * 0.5;
	[scrollView setContentOffset:offset];
	
	// Enable zooming
	[scrollView setMinimumZoomScale:0.5];
	[scrollView setMaximumZoomScale:5];
	[scrollView setDelegate:self];
	
	// Create the view
	view = [[Hypnosister alloc] initWithFrame:bigRect];
	[view setBackgroundColor:[UIColor clearColor]];
	[scrollView addSubview:view];
	
	// Get build error from this!?
	//[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	 
	[window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc 
{
	[view release];
    [window release];
    [super dealloc];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return view;
}

@end
