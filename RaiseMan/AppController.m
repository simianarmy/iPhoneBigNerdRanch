//
//  AppController.m
//  RaiseMan
//
//  Created by Marc Mauger on 9/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

+ (void)initialize
{
	// Create a dictionary
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	// Archive the color object
	NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor yellowColor]];
	
	// Put defaults in the dictionary
	[defaultValues setObject:colorAsData forKey:BNRTableBgColorKey];
	[defaultValues setObject:[NSNumber numberWithBool:YES]
					  forKey:BNREmptyDocKey];
	
	// Register the dictionary of defaults
	[[NSUserDefaults standardUserDefaults]
	 registerDefaults:defaultValues];
	NSLog(@"registered defaults: %@", defaultValues);	
}

- (IBAction)showPreferencePanel:(id)sender
{
	// Is preferenceController nil?
	if (!preferenceController) {
		preferenceController = [[PreferenceController alloc] init];
	}
	NSLog(@"showing %@", preferenceController);
	[preferenceController showWindow:self];
}

- (IBAction)showAboutPanel:(id)sender
{
	NSLog(@"showing about panel from bundle");
	[NSBundle loadNibNamed:@"About" owner:self];
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	NSLog(@"applicationdShouldOpenUntitledFile");
	return [[NSUserDefaults standardUserDefaults]
			boolForKey:BNREmptyDocKey];
}

- (void)applicationDidResignActive:(NSNotification *)notification
{
	NSBeep();
}

@end
