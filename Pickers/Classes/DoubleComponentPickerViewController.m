//
//  DoubleComponentPickerViewController.m
//  Pickers
//
//  Created by Marc Mauger on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DoubleComponentPickerViewController.h"


@implementation DoubleComponentPickerViewController
@synthesize doublePicker;
@synthesize pickerData;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSArray *array1 = [[NSArray alloc] initWithObjects:@"fee",
					   @"fy", @"fo", @"fum", @"roast beef", @"lamb's bread", nil];
	NSArray *array2 = [[NSArray alloc] initWithObjects:@"frot",
					   @"blot", @"kot", @"mein got", nil];
	
	NSArray *array = [[NSArray alloc] initWithObjects:array1, array2, nil];
	
	self.pickerData = array;
	
	[array release];
	[array1 release];
	[array2 release];
}

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
	self.doublePicker = nil;
	self.pickerData = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[doublePicker release];
	[pickerData release];
    [super dealloc];
}

- (IBAction)buttonPressed {
	NSInteger mainRow = [doublePicker selectedRowInComponent:kPickerMainCourse];
	NSInteger breadRow = [doublePicker selectedRowInComponent:kPickerBread];

	NSString *mainSelected = [[pickerData objectAtIndex:kPickerMainCourse] objectAtIndex:mainRow];
	NSString *breadSelected = [[pickerData objectAtIndex:kPickerBread] objectAtIndex:breadRow];

	NSString *title = [[NSString alloc] initWithFormat:@"You selected %@ with %@!", 
					   mainSelected, breadSelected];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:@"Yum, I guess"
												   delegate:nil 
										  cancelButtonTitle:@"no prob" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[title release];
}

#pragma mark -
#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return [pickerData count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
	return [[pickerData objectAtIndex:component] count];
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow:(NSInteger)row
			forComponent:(NSInteger)component {
	return [[pickerData objectAtIndex:component] objectAtIndex:row];
}

@end
