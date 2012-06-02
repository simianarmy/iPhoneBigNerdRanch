    //
//  TableController.m
//  Nayberz
//
//  Created by Marc Mauger on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableController.h"
#import <netinet/in.h>
#import <arpa/inet.h>

@implementation TableController

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

- (id)init
{
	[super initWithStyle:UITableViewStylePlain];
	
	// Create an empty array
	netServices = [[NSMutableArray alloc] init];
	
	serviceBrowser = [[NSNetServiceBrowser alloc] init];
	
	// As the delegate, you will be told when services are found
	[serviceBrowser setDelegate:self];
	
	// Start it up
	[serviceBrowser searchForServicesOfType:@"_nayberz._tcp." inDomain:@""];
	
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	return [self init];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
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


- (void)dealloc {
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)table
numberOfRowsInSection:(NSInteger)section
{
	return [netServices count];
}

- (UITableViewCell *)tableView:(UITableView *)tv
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNetService *ns = [netServices objectAtIndex:[indexPath row]];
	
	NSString *message = nil;
	
	// Try to get the TXT record
	NSData *data = [ns TXTRecordData];
	
	// Is there TXT data? (no TXT data in unresolved services)
	if (data) {
		// Convert it into a dictionary
		NSDictionary *txtDict = [NSNetService dictionaryFromTXTRecordData:data];
		
		// Get the data that the publisher pu in under the message key
		NSData *mData = [txtDict objectForKey:@"message"];
		
		// Is there data?
		if (mData) {
			// Make a string
			message = [[NSString alloc] initWithData:mData
											encoding:NSUTF8StringEncoding];
			[message autorelease];
		}
	}
	// Did I fail to get a string?
	if (!message) {
		// Use a default
		message = @"<No message>";
	}
	
	UITableViewCell *cell = [[self tableView]
							 dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
									  reuseIdentifier:@"UITableViewCell"];
		[cell autorelease];
	}
	// Name on the left
	[[cell textLabel] setText:[ns name]];
	
	// Message on the right
	[[cell detailTextLabel] setText:message];
	
	return cell;
}

// Called when services are found
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
		   didFindService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing
{
	NSLog(@"adding %@", aNetService);
	
	// Add it to the array
	[netServices addObject:aNetService];
	
	// Update the interface
	NSIndexPath *ip = [NSIndexPath indexPathForRow:[netServices count] - 1
										 inSection:0];
	[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
							withRowAnimation:UITableViewRowAnimationRight];
	
	// Start resolution to get TXT record
	// The success or failure of the resolution will be sent to the delegate
	[aNetService setDelegate:self];
	// Give 30 seconds to figure out additional info, else fail.
	[aNetService resolveWithTimeout:30];
}

// Called when services are lost
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
		 didRemoveService:(NSNetService *)aNetService
			   moreComing:(BOOL)moreComing
{
	NSLog(@"removing %@", aNetService);
	
	// Take it out of the array
	NSUInteger row = [netServices indexOfObject:aNetService];
	if (row == NSNotFound) {
		NSLog(@"unable to find the service in %@", netServices);
		return;
	}
	[netServices removeObjectAtIndex:row];
	
	// Update the interface
	NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
	[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip]
							withRowAnimation:UITableViewRowAnimationRight];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	// What row just resolved?
	int row = [netServices indexOfObjectIdenticalTo:sender];
	NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
	NSArray *ips = [NSArray arrayWithObject:ip];
	
	// Reload that row - the data source will pull the TXT record out
	[[self tableView] reloadRowsAtIndexPaths:ips withRowAnimation:UITableViewRowAnimationRight];
	
	// Get all addresses for this server
	NSArray *addrs = [sender addresses];
	if ([addrs count] > 0) {
		// Just grab the first address that it advertises
		NSData *firstAddress = [addrs objectAtIndex:0];
		
		// Point a sockaddr_in structure at the data wrapped by first address
		const struct sockaddr_in *addy = [firstAddress bytes];
		
		// Get a string that shows the IP address in x.x.x.x format
		// from the sockaddr_in struct
		char *str = inet_ntoa(addy->sin_addr);
		
		// Print that IP address as well as the port
		NSLog(@"%s:%d", str, ntohs(addy->sin_port));
	}
}



@end
