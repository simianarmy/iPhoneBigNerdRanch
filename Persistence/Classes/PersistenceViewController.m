//
//  PersistenceViewController.m
//  Persistence
//
//  Created by Marc Mauger on 7/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PersistenceViewController.h"

@implementation PersistenceViewController
@synthesize field1;
@synthesize field2;
@synthesize field3;
@synthesize field4;

- (NSString *)dataFilePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
														 NSDocumentDirectory, 
														 NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	/*
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:field1.text];
	[array addObject:field2.text];
	[array addObject:field3.text];
	[array addObject:field4.text];
	[array writeToFile:[self dataFilePath] atomically:YES];
	[array release];
	 */
	for (int i=1; i<=4; i++) {
		NSString *fieldName = [[NSString alloc]
							   initWithFormat:@"field%d", i];
		UITextField *field = [self valueForKey:fieldName];
		[fieldName release];
		
		char *errorMsg;
		char *update = "INSERT OR REPLACE INTO FIELDS (ROW, FIELD_DATA) VALUES (?, ?);";
		sqlite3_stmt *stmt;
		if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) 
			== SQLITE_OK) {
			sqlite3_bind_int(stmt, 1, i);
			sqlite3_bind_text(stmt, 2, [field.text UTF8String], -1, NULL);
		}
		if (sqlite3_step(stmt) != SQLITE_DONE)
			NSAssert1(0, @"Error updating table: %s", errorMsg);
		sqlite3_finalize(stmt);
	}
	sqlite3_close(database);
}

#pragma mark -

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	/*
	NSString *filePath = [self dataFilePath];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		NSArray *array = [[NSArray alloc] initWithContentsOfFile:filePath];
		field1.text = [array objectAtIndex:0];
		field2.text = [array objectAtIndex:0];
		field3.text = [array objectAtIndex:0];
		field4.text = [array objectAtIndex:0];
		[array release];
	}
	 */
	if (sqlite3_open([[self dataFilePath] UTF8String], &database)
		!= SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0, @"Failed to open database");
	}
	char *errorMsg;
	NSString *createSQL = @"CREATE TABLE IF NOT EXISTS FIELDS (ROW INTEGER PRIMARY KEY, FIELD_DATA TEXT);";
	if (sqlite3_exec(database, [createSQL UTF8String],
					 NULL, NULL, &errorMsg) != SQLITE_OK) {
		sqlite3_close(database);
		NSAssert1(0, @"Error creating table: %s", errorMsg);
	}
	NSString *query = @"SELECT ROW, FIELD_DATA FROM FIELDS ORDER BY ROW";
	sqlite3_stmt *statement;
	if (sqlite3_prepare_v2(database, [query UTF8String], 
						   -1, &statement, nil) == SQLITE_OK) {
		while (sqlite3_step(statement) == SQLITE_ROW) {
			int row = sqlite3_column_int(statement, 0);
			char *rowData = (char *)sqlite3_column_text(statement, 1);
			
			NSString *fieldName = [[NSString alloc]
								   initWithFormat:@"field%d", row];
			NSString *fieldValue = [[NSString alloc]
									initWithUTF8String:rowData];
			UITextField *field = [self valueForKey:fieldName];
			field.text = fieldValue;
			[fieldName release];
			[fieldValue release];
		}
		sqlite3_finalize(statement);
	}
	
	UIApplication *app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app];
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.field1 = nil;
	self.field2 = nil;
	self.field3 = nil;
	self.field4 = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[field1 release];
	[field2 release];
	[field3 release];
	[field4 release];
    [super dealloc];
}

@end
