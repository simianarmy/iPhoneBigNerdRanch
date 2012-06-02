//
//  AppController.h
//  AmaZone
//
//  Created by Marc Mauger on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppController : NSObject {
	IBOutlet NSProgressIndicator *progress;
	IBOutlet NSProgressIndicator *webViewProgress;
	IBOutlet NSTextField *searchField;
	IBOutlet NSTableView *tableView;
	IBOutlet NSWindow *webWindow;
	IBOutlet WebView *webView;
	NSXMLDocument *doc;
	NSArray *itemNodes;
	
}
- (IBAction)fetchBooks:(id)sender;
- (IBAction)endWebViewSheet:(id)sender;

@end
