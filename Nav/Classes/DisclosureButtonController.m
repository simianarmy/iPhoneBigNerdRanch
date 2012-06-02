//
//  DisclosureButtonController.m
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DisclosureButtonController.h"
#import "NavAppDelegate.h"
#import "DisclosureDetailController.h"

@implementation DisclosureButtonController
@synthesize list;

- (void)viewDidLoad {
	NSArray *array = [[NSArray alloc] initWithObjects:@"Toy Story",
					  @"A Bug's Life", @"Rambo: First Blood",
					  @"Terminator 5", nil];
	self.list = array;
	[array release];
	[super viewDidLoad];
}

- (void)viewDidUnload {
	self.list = nil;
	[childController release];
}

- (void)dealloc {
	[list release];
	[childController release];
	[super dealloc];
}

#pragma Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *DisclosureButtonCellIdentifier = @"DisclosureButtonCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 DisclosureButtonCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:DisclosureButtonCellIdentifier] autorelease];
	}
	// Configure the cell
	NSUInteger row = [indexPath row];
	NSString *rowString = [list objectAtIndex:row];
	cell.textLabel.text = rowString;
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	[rowString release];
	return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:
						  @"Hey, fuck you"
													message:@"no drilling"
												   delegate:nil
										  cancelButtonTitle:@"fooo"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (childController == nil)
		childController = [[DisclosureDetailController alloc]
						   initWithNibName:@"DisclosureDetail" bundle:nil];
	
	childController.title = @"Disclosure Button Pressed";
	NSUInteger row = [indexPath row];
	
	NSString *selectedMovie = [list objectAtIndex:row];
	NSString *detailMessage = [[NSString alloc]
							   initWithFormat:@"You pressed button for %@",
							   selectedMovie];
	childController.message = detailMessage;
	childController.title = selectedMovie;
	[detailMessage release];
	[self.navigationController pushViewController:childController
										 animated:YES];
}

@end
