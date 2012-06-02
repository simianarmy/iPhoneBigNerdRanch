//
//  ItemAccessoryCell.h
//  Homepwner
//
//  Created by Marc Mauger on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Possession;
@interface ItemAccessoryCell : UITableViewCell 
{
	UILabel *serialLabel;
	UILabel *dateCreatedLabel;
	UILabel *nameLabel;
	UILabel *valueLabel;
	int accessoryViewMode;
}
- (void)setPossession:(Possession *)possession;
- (void)toggleCellAccessoryView;

@end
