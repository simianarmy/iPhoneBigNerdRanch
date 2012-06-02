//
//  NayberzAppDelegate.m
//  Nayberz
//
//  Created by Marc Mauger on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NayberzAppDelegate.h"
#import "TableController.h"

@implementation NayberzAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Create an instance of NSNetService
	netService = [[NSNetService alloc] initWithDomain:@"" 
												 type:@"_nayberz._tcp." 
												 name:[[UIDevice currentDevice] name] 
												 port:9090];
	// As the delegate, you will know if the publish is successful
	[netService setDelegate:self];
	
	NSString *messageString = @"You all kinda smell";
	[self setMessage:messageString forNetService:netService];
	
	// Try to publish it
	[netService publish];
    
	TableController *tableController = [[[TableController alloc] init] autorelease];
	[window setRootViewController:tableController];
	[application setStatusBarHidden:YES];
	
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[netService stop];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	[netService publish];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

- (void)setMessage:(NSString *)str forNetService:(NSNetService *)service
{
	// Pack the string into an NSData
	NSData *d = [str dataUsingEncoding:NSUTF8StringEncoding];
	// Put the data in a dictionary
	NSDictionary *txtDict = [NSDictionary dictionaryWithObject:d forKey:@"message"];
	// pack the dictionary into an NSDdata
	NSData *txtData = [NSNetService dataFromTXTRecordDictionary:txtDict];
	// Put that data into the net service
	[service setTXTRecordData:txtData];
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
	NSLog(@"published: %@", sender);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
	NSLog(@"not published: %@ -> %@", sender, errorDict);
}


@end
