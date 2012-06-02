//
//  MyDocument.h
//  ZIPInspector
//
//  Created by Marc Mauger on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
	IBOutlet NSTableView *tableView;
	NSArray *filenames;
}
- (int)numberOfRowsInTableView:(NSTableView *)v;
- (id)tableView:(NSTableView *)tv 
objectValueForTableColumn:(NSTableColumn *)tc
			row:(NSInteger)row;
@end
