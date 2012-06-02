//
//  ItemDetailViewController.m
//  Homepwner
//
//  Created by Marc Mauger on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Possession.h"
#import "ImageCache.h"

@implementation ItemDetailViewController

@synthesize editingPossession;

- (id)init
{
	[super initWithNibName:@"ItemDetailViewController" bundle:nil];
	
	// Create a UIBarButtonItem with a camera icon
	UIBarButtonItem *cameraBarButtonItem = 
	[[UIBarButtonItem alloc]
	 initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
	 target:self
	 action:@selector(takePicture:)];
	
	// Place this image on our navigation bar when this viewcontroller 
	// is on top of the nav stack
	[[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
	
	// cameraBarButton is retained by the navigation item
	[cameraBarButtonItem release];
	return self;
}
	
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self init];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[nameField release];
	nameField = nil;
	
	[serialNumberField release];
	serialNumberField = nil;
	
	[valueField release];
	valueField = nil;
	
	[dateLabel release];
	dateLabel = nil;
	
	[imageView release];
	imageView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[nameField setText:[editingPossession possessionName]];
	[serialNumberField setText:[editingPossession serialNumber]];
	[valueField setText:[NSString stringWithFormat:@"%d", 
						 [editingPossession valueInDollars]]];
	
	// Create a NSDateFormatter that will turn a date into a simple date string
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	[dateLabel setText:
	 [dateFormatter stringFromDate:[editingPossession dateCreated]]];
	
	// Change the navigation item to display name of possession
	[[self navigationItem] setTitle:[editingPossession possessionName]];
	
	NSString *imageKey = [editingPossession imageKey];
	
	if (imageKey) {
		UIImage *imageToDisplay = 
		[[ImageCache sharedImageCache] imageForKey:imageKey];
		
		[imageView setImage:imageToDisplay];
		[clearImageButton setHidden:NO];
	} else {
		[imageView setImage:nil];
		[clearImageButton setHidden:YES];
	}
	[inheritorNameField setText:[editingPossession inheritorName]];
	[inheritorNumberField setText:[editingPossession inheritorNumber]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	// Clear first responder
	[nameField resignFirstResponder];
	[serialNumberField resignFirstResponder];
	[valueField resignFirstResponder];
	
	// "Save" changes to editingPossession
	[editingPossession setPossessionName:[nameField text]];
	[editingPossession setSerialNumber:[serialNumberField text]];
	[editingPossession setValueInDollars:[[valueField text] intValue]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)dealloc {
	[nameField release];
	[serialNumberField release];
	[valueField release];
	[dateLabel release];
	[imageView release];
    [super dealloc];
}

- (void)takePicture:(id)sender
{
	[[self view] endEditing:YES];
	
	UIImagePickerController *imagePicker = 
	[[UIImagePickerController alloc] init];
	
	// If our device has a camera, we want to take a picture, otherwise, we
	// just pick from photo library
	if ([UIImagePickerController
		 isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
	} else {
		[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
	// image picker needs a delegate so we can respond to its messages
	[imagePicker setDelegate:self];

	// Place image picker on screen
	// -- If the app is being run on an iPad...
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		// Get rid of the previous popover controller
		[imagePickerPopover release];
		
		imagePickerPopover = [[UIPopoverController alloc]
							  initWithContentViewController:imagePicker];
		
		// Display the popover controller - sender here is the camera bar 
		// button item
		[imagePickerPopover presentPopoverFromBarButtonItem:sender 
								   permittedArrowDirections:UIPopoverArrowDirectionAny 
												   animated:YES];
	} else {
		// If on the iPhone/iPod
		[self presentModalViewController:imagePicker animated:YES];
	}
	[imagePicker release];
}

- (void)chooseInheritor:(id)sender
{
	// Allocate a people picker object
	ABPeoplePickerNavigationController *peoplePicker = 
	[[ABPeoplePickerNavigationController alloc] init];
	
	// Give our people picker a delegate so we can respond to messages
	[peoplePicker setPeoplePickerDelegate:self];
	
	// Put that people picker on the screen
	[self presentModalViewController:peoplePicker animated:YES];
	
	[peoplePicker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *oldKey = [editingPossession imageKey];
	
	// Did the possession already have an image?
	if (oldKey) {
		// Delete the old image
		[[ImageCache sharedImageCache] deleteImageForKey:oldKey];
	}
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	// Create a CFUUID object
	CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
	
	// Create a string from unique identifier
	CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
	
	// Use that unique ID to set our possessions imageKey
	[editingPossession setImageKey:(NSString *)newUniqueIDString];
	
	CFRelease(newUniqueID);
	CFRelease(newUniqueIDString);
	
	// Store image in the ImageCache with this key
	[[ImageCache sharedImageCache] setImage:image
									 forKey:[editingPossession imageKey]];
	
	// Put that image onto the screen in our image view
	[imageView setImage:image];
	
	// Take image picker off the screen - you must call this dismiss method
	[self dismissModalViewControllerAnimated:YES];
	
	[editingPossession setThumbnailDataFromImage:image];
	
	// This line does nothing on the iPhone
	[imagePickerPopover dismissPopoverAnimated:YES];
}

- (void)clearImage:(id)sender
{
	NSString *oldKey = [editingPossession imageKey];
	
	// Did the possession already have an image?
	if (oldKey) {
		// Delete the old image
		[[ImageCache sharedImageCache] deleteImageForKey:oldKey];
	}
	[imageView setImage:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	// Take picker off the screen
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)p
shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	// Get first and last name from the selected person
	NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	
	// Get all of the phone numbers for this selected person
	ABMultiValueRef numbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
	
	// Make sure we have at least one phone number for this person
	if (ABMultiValueGetCount(numbers) > 0) {
		// Grab the first phone number we see
		CFStringRef number = ABMultiValueCopyValueAtIndex(numbers, 0);
		// Add that phone number to the possession object we are editing
		[editingPossession setInheritorNumber:(NSString *)number];
		// Set the on screen UILabel to this phone number
		[inheritorNumberField setText:(NSString *)number];
		
		// We used "Copy" to get this value, we need to manually release it
		CFRelease(number);
	}
	// Create a string iwth first and lat name.
	// Ignore last or first if it is null
	NSString *name = [NSString stringWithFormat:@"%@ %@", 
					  (firstName ? firstName : @""),
					  (lastName ? lastName : @"")];
	[editingPossession setInheritorName:name];
	
	// Manually release all copied objects
	[firstName release];
	[lastName release];
	CFRelease(numbers);
	
	// Update onscreen UILabel
	[inheritorNameField setText:name];
	
	// Get people picker object off the screen
	[self dismissModalViewControllerAnimated:YES];
	
	// Do not perform default functionality (which is go to detailed page)
	return NO;
}


@end
