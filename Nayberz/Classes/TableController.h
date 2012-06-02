//
//  TableController.h
//  Nayberz
//
//  Created by Marc Mauger on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableController : UITableViewController 
	<NSNetServiceDelegate, NSNetServiceBrowserDelegate> 
{
	NSMutableArray *netServices;
	NSNetServiceBrowser *serviceBrowser;

}

@end
