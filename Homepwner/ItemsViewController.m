    //
//  ItemsViewController.m
//  Homepwner
//
//  Created by Marc Mauger on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemDetailViewController.h"
#import "HomepwnerItemCell.h"
#import "Possession.h"

@implementation ItemsViewController
@synthesize possessions;

- (id)init
{
	[super initWithStyle:UITableViewStyleGrouped];
	
	// Set the nav bar to have the pre-fab'ed Edit button when 
	// ItemsViewController is on top of the stack
	[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
	
	// Set the title of the nav bar to Homepwner when ItemsViewController
	// is on top of the stack
	[[self navigationItem] setTitle:@"Homepwner"];
	
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	return [self init];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[self tableView] reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (UIView *)headerView
{
	if (headerView)
		return headerView;
	
	UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[editButton setTitle:@"Edit" forState:UIControlStateNormal];
	
	// How wide is the screen?
	float w = [[UIScreen mainScreen] bounds].size.width;
	
	// Create a rectangle for the button
	CGRect editButtonFrame = CGRectMake(8.0, 8.0, w - 16.0, 30.0);
	[editButton setFrame:editButtonFrame];
	
	// When this button is tapped, send the message
	// editingButtonPressed: to this instance of ItemsViewController
	[editButton addTarget:self
				   action:@selector(editingButtonPressed:)
		 forControlEvents:UIControlEventTouchUpInside];
	
	// Create a rect for the headerView
	CGRect headerViewFrame = CGRectMake(0, 0, w, 48);
	headerView = [[UIView alloc] initWithFrame:headerViewFrame];
	
	// Add button to the headerView's view hierarchy
	[headerView addSubview:editButton];
	
	return headerView;
}
	
- (void)editingButtonPressed:(id)sender
{
	// If we are currently in editing mode...
	if ([self isEditing]) {
		[sender setTitle:@"Edit" forState:UIControlStateNormal];
		// Turn off editing mode
		[self setEditing:NO animated:YES];
	} else {
		[sender setTitle:@"Done" forState:UIControlStateNormal];
		// Enter editing mode
		[self setEditing:YES animated:YES];
	}
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
	[super setEditing:flag animated:animated];
	
	if (flag) {
		NSIndexPath *indexPath = 
		[NSIndexPath indexPathForRow:[possessions count] inSection:0];
		NSArray *paths = [NSArray arrayWithObject:indexPath];
		[[self tableView] insertRowsAtIndexPaths:paths
								withRowAnimation:UITableViewRowAnimationLeft];
	} else {
		NSIndexPath *indexPath = 
		[NSIndexPath indexPathForRow:[possessions count] inSection:0];
		NSArray *paths = [NSArray arrayWithObject:indexPath];
		[[self tableView] deleteRowsAtIndexPaths:paths
								withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If the table view is asking to commit a delete command...
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// We remove the row being deleted from the possessions array
		[possessions removeObjectAtIndex:[indexPath row]];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// If style was insertion, we add a new possession object and new row 
		// to the table view
		[possessions addObject:[Possession randomPossession]];
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationLeft];
	}
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath
{
	Possession *p = [possessions objectAtIndex:[fromIndexPath row]];
	
	// Retain p so that its not deallocated when it is removed from the array
	[p retain];
	// Retain count of p is now 2
	
	// p is automatically sent release
	[possessions removeObjectAtIndex:[fromIndexPath row]];
	// Retain count of p is now 1
	
	// Re-insert - it is automatically retained
	[possessions insertObject:p atIndex:[toIndexPath row]];
	// Retain count of p is now 2
	
	// Release p
	[p release];
	// Retain count of p is now 1
}

- (BOOL)tableView:(UITableView *)tableView 
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Only allow rows showing possessions to move
	if ([indexPath row] < [possessions count])
		return YES;
	return NO;
}

#pragma mark UITableViewDataSource functions

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	int numberOfRows = [possessions count];
	// If we are editing, we will have 1+ row than we have possessions
	if ([self isEditing]) 
		numberOfRows++;
	
	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// This will occur when editing, extra row that shows "Ad New item..."
	if ([indexPath row] >= [possessions count]) {
		// Create a basic cell
		UITableViewCell *cell = 
		[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
		
		// If there is no reusable cell of this type, create a new one
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
								reuseIdentifier:@"UITableViewCell"] autorelease];
		}
		// Set its label
		[[cell textLabel] setText:@"Add New item..."];
		return cell;
	}
	// Get instance of a HomepwnerItemCell - either an unused one or a new one
	HomepwnerItemCell *cell = (HomepwnerItemCell *)[tableView 
													dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
	if (!cell) {
		cell = [[[HomepwnerItemCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:@"HomepwnerItemCell"] autorelease];
	}
	Possession *p = [possessions objectAtIndex:[indexPath row]];
	[cell setPossession:p];
	[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
		
	return cell;
}

- (void)tableView:(UITableView *)tableView 
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"accessoryButtonTappedForRowWithIndexPath for row %d", [indexPath row]);
	HomepwnerItemCell *cell =  (HomepwnerItemCell *)[tableView cellForRowAtIndexPath:indexPath];
	if (cell) {
		[cell accessoryButtonTapped];
	}
	//[tableView reloadData];
}

#pragma mark UITableViewDelegate functions

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self isEditing] && [indexPath row] == [possessions count]) {
		// The last row during editing will show an insert style button
		return UITableViewCellEditingStyleInsert;
	}
	// All other rows remain deleteable
	return UITableViewCellEditingStyleDelete;
}

- (NSIndexPath *)tableView:(UITableView *)tableView 
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if ([proposedDestinationIndexPath row] < [possessions count]) {
		return proposedDestinationIndexPath;
	}
	// We get here if we are trying to move a row to under the "Add New Item..." 
	// row, have the moving row go one row above it instead.
	NSIndexPath *betterIndexPath =
	[NSIndexPath indexPathForRow:[possessions count] - 1 inSection:0];
	
	return betterIndexPath;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Do I need to create the instance of ItemDetailViewController?
	if (!detailViewController) {
		detailViewController = [[ItemDetailViewController alloc] init];
	}
	// Give detail view controller a pointer to the possession object
	[detailViewController setEditingPossession:
	 [possessions objectAtIndex:[indexPath row]]];
	
	// Push it onto the top of the navigation controller's stack
	[[self navigationController] pushViewController:detailViewController
										   animated:YES];
}

@end
