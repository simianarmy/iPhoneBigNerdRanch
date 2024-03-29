//
//  MyDocument.m
//  RaiseMan2
//
//  Created by Marc Mauger on 8/21/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import "MyDocument.h"
#import "Person.h"

@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		employees = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
	[employees release];
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
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

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
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

#pragma mark Action methods

- (IBAction)deleteSelectedEmployees:(id)sender
{
	NSLog(@"delete button pushed");
	NSIndexSet *rows = [tableView selectedRowIndexes];
	
	if ([rows count] == 0) {
		NSBeep();
		return;
	}
	[employees removeObjectsAtIndexes:rows];
	[tableView reloadData];
}

- (IBAction)createEmployee:(id)sender
{
	NSLog(@"createEmployee button pushed");
	
	Person *newEmployee = [[Person alloc] init];
	[employees addObject:newEmployee];
	
	[newEmployee release];
	[tableView reloadData];
}

# pragma mark Table view dataSource methods

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [employees count];
}

- (id)tableView:(NSTableView *)aTableView 
		objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(int)rowIndex
{
	NSString *identifier = [aTableColumn identifier];
	
	// What person?
	Person *person = [employees objectAtIndex:rowIndex];
	
	// What is the value of the attribute named identifier?
	return [person valueForKey:identifier];
}

- (void)tableView:(NSTableView *)aTableView
setObjectValue:(id)anObject
forTableColumn:(NSTableColumn *)aTableColumn
row:(int)rowIndex
{
	NSString *identifier = [aTableColumn identifier];
	Person *person = [employees objectAtIndex:rowIndex];
	
	// Set value for the attr named identifier
	[person setValue:anObject forKey:identifier];
}

- (void)tableView:(NSTableView *)aTableView
sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
	NSArray *newDescriptors = [aTableView sortDescriptors];
	[employees sortUsingDescriptors:newDescriptors];
	[tableView reloadData];
}


@end
