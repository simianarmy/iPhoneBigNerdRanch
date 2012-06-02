    //
//  ItemsViewController.m
//  Homepwner
//
//  Created by Marc Mauger on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemsViewController.h"
#import "Possession.h"

@implementation ItemsViewController

- (id)init
{
	[super initWithStyle:UITableViewStyleGrouped];
	
	// Create 2 array of 10 total random possessions, 
	// divided into dollar value.
	possessions[0] = [[NSMutableArray alloc] init];
	possessions[1] = [[NSMutableArray alloc] init];
	
	for (int i=0; i<10; i++) {
		Possession *p = [Possession randomPossession];
		if ([p valueInDollars] > 50.0) {
			[possessions[1] addObject:p];
		} else {
			[possessions[0] addObject:p];
		}
	}
	
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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"Cheap stuff";
	} else {
		return @"Dear stuff";
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	return [possessions[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	
	// If there is no reusable cell of this type, create a new one
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
							reuseIdentifier:@"UITableViewCell"] autorelease];
	}
	Possession *p = [possessions[[indexPath section]] objectAtIndex:[indexPath row]];
	[[cell textLabel] setText:[p description]];
	return cell;
}

@end
