//
//  AppController.m
//  AmaZone
//
//  Created by Marc Mauger on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "HMACSHA256.h"

#define AWS_ID @"AKIAILGXT362XEREOEDQ"
#define AWS_SECRET	@"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"

@interface AppController ()
- (void)showAlert:(NSError *)err;
- (NSString *)stringForPath:(NSString *)xp ofNode:(NSXMLNode *)n;
@end

@implementation AppController


- (void)awakeFromNib
{
	[tableView setDoubleAction:@selector(openItem:)];
	[tableView setTarget:self];
	[webView setFrameLoadDelegate:self];
}

#pragma mark Events


- (IBAction)fetchBooks:(id)sender
{
	// Show the user that something is going on
	[progress startAnimation:nil];
	
	// Put together the request
	NSString *input = [searchField stringValue];
	NSString *searchString = [input stringByAddingPercentEscapesUsingEncoding:
							  NSUTF8StringEncoding];
	NSLog(@"searchString = %@", searchString);
	
	// Create the URL
	NSString *urlString = [NSString stringWithFormat:
						   @"http://ecs.amazonaws.com/onca/xml?"
						   @"Service=AWSECommerceService&"
						   @"AWSAccessKeyId=%@&"
						   @"Operation=ItemSearch&"
						   @"SearchIndex=Books&"
						   @"Keywords=%@&"
						   @"Version=2007-07-16",
						   AWS_ID, searchString];
	
	NSString *signedURLString = [HMACSHA256 getSignedRequest:urlString withSecret:AWS_SECRET];
	NSURL *url	= [NSURL URLWithString:signedURLString];

	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	
		
	// Fetch XML
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest 
									returningResponse:&response 
												error:&error];
	if (!urlData) {
		[self showAlert:error];
		return;
	}
	// Parse XML
	[doc release];
	doc = [[NSXMLDocument alloc] initWithData:urlData
									options:0
										error:&error];
	NSLog(@"doc = %@", doc);
	if (!doc) {
		[self showAlert:error];
		return;
	}
	[itemNodes release];
	itemNodes = [[doc nodesForXPath:@"ItemSearchResponse/Items/Item"
							  error:&error] retain];
	if (!itemNodes) {
		[self showAlert:error];
		return;
	}
	// Update the interface
	[tableView reloadData];
	[progress stopAnimation:nil];
}

- (IBAction)endWebViewSheet:(id)sender
{
	NSLog(@"closing sheet");
	// Retrun to normal event handling
	[NSApp endSheet:webWindow];
	
	// Hide the sheet
	[webWindow orderOut:sender];
}


- (NSString *)stringForPath:(NSString *)xp ofNode:(NSXMLNode *)n
{
	NSError *error;
	NSArray *nodes = [n nodesForXPath:xp error:&error];
	if (!nodes) {
		[self showAlert:error];
		return nil;
	}
	if ([nodes count] == 0) {
		return nil;
	} else {
		return [[nodes objectAtIndex:0] stringValue];
	}
}

- (void)showAlert:(NSError *)err
{
	[[NSAlert alertWithError:err] runModal];
}

- (void)openItem:(id)sender
{
	int row = [tableView clickedRow];
	if (row == -1) {
		return;
	}
	NSXMLNode *clickedItem = [itemNodes objectAtIndex:row];
	NSString *urlString = [self stringForPath:@"DetailPageURL"
									   ofNode:clickedItem];
	//NSURL *url = [NSURL URLWithString:urlString];
	
	//[[NSWorkspace sharedWorkspace] openURL:url];
	// Send window the url to load before displaying the sheet
	
	[webView setMainFrameURL:urlString];
	
	[NSApp beginSheet:webWindow
	  modalForWindow:[tableView window]
	   modalDelegate:self
	  didEndSelector:NULL
		 contextInfo:NULL];
}

#pragma mark TableView data source methods

- (int)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [itemNodes count];
}

- (id)tableView:(NSTableView *)tv
objectValueForTableColumn:(NSTableColumn *)tableColumn
row:(int)row
{
	NSXMLNode *node = [itemNodes objectAtIndex:row];
	NSString *xPath = [tableColumn identifier];
	return [self stringForPath:xPath ofNode:node];
}

#pragma mark delegates

- (void)webView:(WebView *)wv didStartProvisionalLoadForFrame:(WebFrame *)wf
{
	NSLog(@"didStartProvisionalLoadForFrame");
	[webViewProgress startAnimation:nil];
}

- (void)webView:(WebView *)wv
	didFinishLoadForFrame:(WebFrame *)wf
{
	NSLog(@"didFinishLoadForFrame");
	[webViewProgress stopAnimation:nil];
}

- (void)webView:(WebView *)wv didFailProvisionalLoadWithError:(NSError *)error
	   forFrame:(WebFrame *)wf
{
	NSLog(@"didFailProvisionalLoadWithError");
}

@end
