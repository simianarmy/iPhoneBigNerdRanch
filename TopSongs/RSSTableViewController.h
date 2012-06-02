//
//  RSSTableViewController.h
//  TopSongs
//
//  Created by Marc Mauger on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSSTableViewController : UITableViewController 
<NSXMLParserDelegate> {
	BOOL waitingForEntryTitle;
	NSMutableString *titleString;
	NSMutableArray *songs;
	NSMutableData *xmlData;
	NSURLConnection *connectionInProgress;
}
- (void)loadSongs;

@end
