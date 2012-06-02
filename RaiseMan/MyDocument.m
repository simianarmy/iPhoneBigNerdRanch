//
//  MyDocument.m
//  RaiseMan
//
//  Created by Marc Mauger on 8/21/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import "MyDocument.h"
#import "Person.h"
#import "PreferenceController.h"

@implementation MyDocument

- (id)init
{
    if (![super init])
		return nil;
	
	// If an error occurs here, send a [self release] message and return nil.
	employees = [[NSMutableArray alloc] init];
    
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(handleColorChange:) name:BNRColorChangedNotification object:nil];
	NSLog(@"Registered with notification center");
	
    return self;
}

- (void)dealloc
{
	[self setEmployees:nil];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	[super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *colorAsData;
	colorAsData = [defaults objectForKey:BNRTableBgColorKey];
	
	[tableView setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorAsData]];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
	
	// End editing
	[[tableView window] endEditingFor:nil];
	
	// Create an NSData object from the employees array
	return [NSKeyedArchiver archivedDataWithRootObject:employees];
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
	NSLog(@"About to read data of type %@", typeName);
	NSMutableArray *newArray = nil;
	@try {
		newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	@catch (NSException *e) {
		if (outError) {
			NSDictionary *d = [NSDictionary
							   dictionaryWithObject:@"The data is corrupted." 
							   forKey:NSLocalizedFailureReasonErrorKey];
			*outError = [NSError errorWithDomain:NSOSStatusErrorDomain
											code:unimpErr
										userInfo:d];
		}
		return NO;
	}
	[self setEmployees:newArray];
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

- (IBAction)createEmployee:(id)sender
{
	NSWindow *w = [tableView window];
	
	// Try to end any editing that is taking place
	BOOL editingEnded = [w makeFirstResponder:w];
	if (!editingEnded) {
		NSLog(@"Unable to end editing");
		return;
	}
	NSUndoManager *undo = [self undoManager];
	
	// Has an edit occurred already in this event?
	if ([undo groupingLevel]) {
		[undo endUndoGrouping];
		[undo beginUndoGrouping];
	}
	Person *p = [employeeController newObject];
	
	[employeeController addObject:p];
	[p release];
	// Re-sort
	[employeeController rearrangeObjects];
	// Get sorted array
	NSArray *a = [employeeController arrangedObjects];
	
	// Find the object just added
	int row = [a indexOfObjectIdenticalTo:p];
	NSLog(@"starting edit of %@ in row %d", p, row);
	
	// Begin the edit in the first column
	[tableView editColumn:0 row:row withEvent:nil select:YES];
}

- (IBAction)removeEmployee:(id)sender
{
	NSArray *selectedPeople = [employeeController selectedObjects];
	NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"DELETE", @"Delete")
									 defaultButton:NSLocalizedString(@"DELETE", @"Delete")
								   alternateButton:NSLocalizedString(@"CANCEL", @"Cancel")
									   otherButton:@"Keep, but no raise"
						 informativeTextWithFormat:NSLocalizedString(@"SURE_DELETE", 
					  @"Do you really want to delete %d people?"),
					  [selectedPeople count]];
	NSLog(@"Starting alert sheet");
	[alert beginSheetModalForWindow:[tableView window]
					  modalDelegate:self 
					 didEndSelector:@selector(alertEnded:code:context:)
						contextInfo:NULL];
}


- (void)setEmployees:(NSMutableArray *)a
{
	if (a == employees)
		return;
	
	for (Person *person in employees) {
		[self stopObservingPerson:person];
	}
	[a retain];
	[employees release];
	employees = a;
	
	for (Person *person in employees) {
		[self startObservingPerson:person];
	}
}

- (void)insertObject:(Person *)p inEmployeesAtIndex:(int)index
{
	NSLog(@"adding %@ to %@", p, employees);
	// Add inverse of op to undo stack
	NSUndoManager *undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] removeObjectFromEmployeesAtIndex:index];
	if (![undo isUndoing]) {
		[undo setActionName:@"Insert Person"];
	}
	// Add Person to the array
	[self startObservingPerson:p];
	[employees insertObject:p atIndex:index];
}

- (void)removeObjectFromEmployeesAtIndex:(int)index
{
	Person *p = [employees objectAtIndex:index];
	NSLog(@"removing %@ from %@", p, employees);
	// Add inverse of op to undo stack
	NSUndoManager *undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self] insertObject:p
									   inEmployeesAtIndex:index];
	if (![undo isUndoing]) {
		[undo setActionName:@"Delete Person"];
	}
	// Add Person to the array
	[self stopObservingPerson:p];
	[employees removeObjectAtIndex:index];
}

- (void)startObservingPerson:(Person *)person
{
	[person addObserver:self
			forKeyPath:@"personName"
			options:NSKeyValueObservingOptionOld
				context:NULL];
	[person addObserver:self forKeyPath:@"expectedRaise" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)stopObservingPerson:(Person *)person
{
	[person removeObserver:self forKeyPath:@"personName"];
	[person removeObserver:self forKeyPath:@"expectedRaise"];
}

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue
{
	[obj setValue:newValue forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSUndoManager *undo = [self undoManager];
	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	
	// NSNull = nil in dictionaries
	if (oldValue == [NSNull null]) {
		oldValue = nil;
	}
	NSLog(@"oldValue = %@", oldValue);
	[[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath 
												  ofObject:object
												   toValue:oldValue];
	[undo setActionName:@"Edit"];
}

- (void)handleColorChange:(NSNotification *)note
{
	NSLog(@"Received notification: %@", note);
	NSColor *color = [[note userInfo] objectForKey:@"color"];
	[tableView setBackgroundColor:color];
}

- (void)alertEnded:(NSAlert *)alert code:(int)choice context:(void *)v
{
	NSLog(@"Alert sheet ended");
	// If user chose "Delete", tell array controller to delete the people
	if (choice == NSAlertDefaultReturn) {
		[employeeController remove:nil];
	} else if (choice == NSAlertOtherReturn) {
		NSArray *selectedPeople = [employeeController selectedObjects];
		for (Person *person in selectedPeople) {
			[person setValue:0 forKeyPath:@"expectedRaise"];
		}
	}
}

@end
