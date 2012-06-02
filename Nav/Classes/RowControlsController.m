//
//  RowControlsController.m
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RowControlsController.h"


@implementation RowControlsController
@synthesize list;

- (IBAction)buttonTapped:(id)sender {
	UIButton *senderButton = (UIButton *)sender;
	UITableViewCell *buttonCell =
	(UITableViewCell *)[senderButton superview];
	NSUInteger buttonRow = [[self.tableView
							 indexPathForCell:buttonCell] row];
	NSString *buttonTitle = [list objectAtIndex:buttonRow];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"you tapped that ass"
						  message:[NSString stringWithFormat:
													@"You tapped the button for %@", buttonTitle]
						  delegate:nil 
						  cancelButtonTitle:@"smokay" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)viewDidLoad {
	NSArray *array = [[NSArray alloc] initWithObjects:@"Who foo",
					  @"r2-d2", @"bender",
					  @"marvin", @"optimus rex", nil];
	self.list = array;
	[array release];
	[super viewDidLoad];
}

- (void)viewDidUnload {
	self.list = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	[list release];
	[super dealloc];
}

#pragma Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *ControlRowIdentifier = @"ControlRowIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 ControlRowIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:ControlRowIdentifier] autorelease];
		UIImage *buttonUpImage = [UIImage imageNamed:@"button_up.png"];
		UIImage *buttonDownImage = [UIImage imageNamed:@"button_down.png"];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0.0, 0.0, buttonUpImage.size.width, buttonUpImage.size.height);
		[button setBackgroundImage:buttonUpImage forState:UIControlStateNormal];
		[button setBackgroundImage:buttonDownImage forState:UIControlStateHighlighted];
		[button setTitle:@"Tap" forState:UIControlStateNormal];
		[button addTarget:self action:@selector(buttonTapped:) 
			forControlEvents:UIControlEventTouchUpInside];
		cell.accessoryView = button;
	}
	NSUInteger row = [indexPath row];
	NSString *rowTitle = [list objectAtIndex:row];
	cell.textLabel.text = rowTitle;
	
	return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];
	NSString *rowTitle = [list objectAtIndex:row];
	UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle:@"You tapped the row!"
						  message:[NSString
								   stringWithFormat:@"you tapped %@, dog", rowTitle]
						  delegate:nil
						  cancelButtonTitle:@"hmmok"
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
