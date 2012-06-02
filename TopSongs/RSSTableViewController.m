//
//  RSSTableViewController.m
//  TopSongs
//
//  Created by Marc Mauger on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSTableViewController.h"


@implementation RSSTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	if (self = [super initWithStyle:style]) {
		songs = [[NSMutableArray alloc] init];
	}
	return self;
}

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self loadSongs];
}

- (void)dealloc {
	[songs release];
    [super dealloc];
}

- (void)loadSongs
{
	// In case the view will appear multiple times, clear the 
	// song list
	[songs removeAllObjects];
	[[self tableView] reloadData];
	
	// Construct the web service URL
	NSURL *url = [NSURL URLWithString:@"http://ax.itunes.apple.com/"
				  @"webObjects/MZStoreServices.woa/ws/RSS/topSongs/"
				  @"limit=10/xml"];
	NSURLRequest *request = 
	[NSURLRequest requestWithURL:url
					 cachePolicy:NSURLRequestReloadIgnoringCacheData
				 timeoutInterval:30];
	// Clear the existing connection if there is one
	if (connectionInProgress) {
		[connectionInProgress cancel];
		[connectionInProgress release];
	}
	// Instantiate the object to hold all incoming data
	[xmlData release];
	xmlData = [[NSMutableData alloc] init];
	
	// Create an initiate the connection - non-blocking
	connectionInProgress = [[NSURLConnection alloc] initWithRequest:request
														   delegate:self
												   startImmediately:YES];
}

#pragma mark Data Source methods

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	return [songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = 
	[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:@"UITableViewCell"] autorelease];
	}
	[[cell textLabel] setText:[songs objectAtIndex:[indexPath row]]];
	[[cell textLabel] setAdjustsFontSizeToFitWidth:YES];
	
	return cell;
}

#pragma mark NSURLConnection functions

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// Create the parser object witht he data received from the web service
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	
	[parser setDelegate:self];
	
	// Tell it to start parsing - the doc. will be parsed and the 
	// delegate of NSXMLParser will get all of its delegate messages
	// sent to it before this line finishes execution - it is blocking
	[parser parse];
	
	// The parser is done (it blocks until done)
	[parser release];
	[[self tableView] reloadData];
}

- (void)connection:(NSURLConnection *)connection
didFailWithError:(NSError *)error
{
	[connectionInProgress release];
	connectionInProgress = nil;
	
	[xmlData release];
	xmlData = nil;
	
	NSString *errorString = [NSString stringWithFormat:@"Fetch failed: %@",
							 [error localizedDescription]];
	UIActionSheet *actionSheet = 
	[[UIActionSheet alloc] initWithTitle:errorString
								delegate:nil
					   cancelButtonTitle:@"OK"
				  destructiveButtonTitle:nil 
					   otherButtonTitles:nil];
	[actionSheet showInView:[[self view] window]];
	[actionSheet autorelease];
}

#pragma mark XML Parsing methods

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqual:@"entry"]) {
		waitingForEntryTitle = YES;
	}
	if ([elementName isEqual:@"title"] && waitingForEntryTitle) {
		NSLog(@"found title!");
		titleString = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[titleString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqual:@"title"] && waitingForEntryTitle) {
		NSLog(@"ended title: %@", titleString);
		[songs addObject:titleString];
		
		[titleString release];
		titleString = nil;
	}
	if ([elementName isEqual:@"entry"]) {
		waitingForEntryTitle = NO;
	}
}

@end
