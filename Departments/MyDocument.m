//
//  MyDocument.m
//  Departments
//
//  Created by Marc Mauger on 11/13/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import "MyDocument.h"
#import "DepartmentViewController.h"
#import "EmployeeViewController.h"

@implementation MyDocument

- (id)init 
{
    self = [super init];
    if (self != nil) {
        viewControllers = [[NSMutableArray alloc] init];
		
		ManagingViewController *vc;
		vc = [[DepartmentViewController alloc] init];
		[vc setManagedObjectContext:[self managedObjectContext]];
		[viewControllers addObject:vc];
		[vc release];
		
		vc = [[EmployeeViewController alloc] init];
		[vc setManagedObjectContext:[self managedObjectContext]];
		[viewControllers addObject:vc];
		[vc release];
	}
    return self;
}

- (void)dealloc
{
	[viewControllers release];
	[super dealloc];
}

- (NSString *)windowNibName 
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
    // user interface preparation code
	NSMenu *menu = [popUp menu];
	int i, itemCount;
	itemCount = [viewControllers count];
	
	for (i=0; i<itemCount; i++) {
		NSViewController *vc = [viewControllers objectAtIndex:i];
		NSMenuItem *mi = [[NSMenuItem alloc] initWithTitle:[vc title]
													action:@selector(changeViewController:)
											 keyEquivalent:@""];
		[mi setTag:i];
		[menu addItem:mi];
		[mi release];
	}
	// Initially show the 1st controller
	[self displayViewController:[viewControllers objectAtIndex:0]];
	[popUp selectItemAtIndex:0];
}

- (void)displayViewController:(ManagingViewController *)vc
{
	// Try to end the editing
	NSWindow *w = [box window];
	BOOL ended = [w makeFirstResponder:w];
	if (!ended) {
		NSBeep();
		return;
	}
	// Put the view in the box
	NSView *v = [vc view];
	
	// Compute the new window frame
	NSSize currentSize = [[box contentView] frame].size;
	NSSize newSize = [v frame].size;
	float deltaWidth  = newSize.width - currentSize.width;
	float deltaHeight = newSize.height - currentSize.height;
	NSRect windowFrame = [w frame];
	windowFrame.size.height += deltaHeight;
	windowFrame.origin.y -= deltaHeight;
	windowFrame.size.width += deltaWidth;
	
	// Clear the box for resizing
	[box setContentView:nil];
	[w setFrame:windowFrame
		display:YES
		animate:YES];
	
	[box setContentView:v];
}

- (IBAction)changeViewController:(id)sender
{
	int i = [sender tag];
	ManagingViewController *vc = [viewControllers objectAtIndex:i];
	[self displayViewController:vc];
}

@end
