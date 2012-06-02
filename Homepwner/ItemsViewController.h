//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Marc Mauger on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;

@interface ItemsViewController : UITableViewController <UITableViewDelegate> {
	NSMutableArray *possessions;
	UIView *headerView;
	ItemDetailViewController *detailViewController;
}
- (UIView *)headerView;
@property (nonatomic, retain) NSMutableArray *possessions;

@end
