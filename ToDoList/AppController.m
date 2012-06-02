//
//  AppController.m
//  ToDoList
//
//  Created by Marc Mauger on 8/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController
- (id)init
{
	[super init];
	
	toDoList = [[NSMutableArray alloc] init];
	return self;
}

- (IBAction)addToDo:(id)sender
{
	NSString *toDoItem = [textField stringValue];
	
	if ([toDoItem length] == 0) {
		return;
	}
	NSLog(@"Added todo item: %@", toDoItem);
	[toDoList addObject:toDoItem];
	// Refresh table view
	[toDoTable reloadData];
	// Clear text field 
	NSString *blank = @"";
	[textField setStringValue:blank];
}

- (int)numberOfRowsInTableView:(NSTableView *)aTable
{
	NSLog(@"# rows in table: %d", [toDoList count]);
	return [toDoList count];
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(int)rowIndex
{
	NSLog(@"returning todo item value at row %d = %@", rowIndex, [toDoList objectAtIndex:rowIndex]);
	return [toDoList objectAtIndex:rowIndex];
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
			  row:(int)rowIndex
{
	NSLog(@"setting todo item value at row %d", rowIndex);
		
	// If item is empty, remove it from the list
	if ([(NSString *)anObject length] == 0) {
		[toDoList removeObjectAtIndex:rowIndex];
	} else {
		[toDoList replaceObjectAtIndex:rowIndex withObject:anObject];
	}
	[toDoTable reloadData];
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn 
			  row:(NSInteger)rowIndex
{
	return (rowIndex < [toDoList count]);
}

@end
