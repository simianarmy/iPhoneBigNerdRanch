//
//  MoveMeController.m
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MoveMeController.h"


@implementation MoveMeController
@synthesize list;

- (IBAction)toggleMove {
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	
	if (self.tableView.editing) {
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	} else {
		[self.navigationItem.rightBarButtonItem setTitle:@"Move"];
	}
}

- (void)dealloc {
	[list release];
	[super dealloc];
}

- (void)viewDidLoad {
	if (list == nil) {
		NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Who foo",
						  @"r2-d2", @"bender",
						  @"marvin", @"optimus rex", nil];
		self.list = array;
		[array release];
	}
	UIBarButtonItem *moveButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Move"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(toggleMove)];
	self.navigationItem.rightBarButtonItem = moveButton;
	[moveButton release];
	[super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MoveMeCellIdentifier = @"MoveMeCellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 MoveMeCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:MoveMeCellIdentifier] autorelease];
		cell.showsReorderControl = YES;
	}
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [list objectAtIndex:row];
	
	return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
	  toIndexPath:(NSIndexPath *)toIndexPath {
	NSUInteger fromRow = [fromIndexPath row];
	NSUInteger toRow = [toIndexPath row];
	
	id object = [[list objectAtIndex:fromRow] retain];
	[list removeObjectAtIndex:fromRow];
	[list insertObject:object atIndex:toRow];
	[object release];
}

@end
