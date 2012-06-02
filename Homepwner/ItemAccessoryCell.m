//
//  ItemAccessoryCell.m
//  Homepwner
//
//  Created by Marc Mauger on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemAccessoryCell.h"
#import "Possession.h"

enum {
	HP_ITEM_CELL_MODE_NORMAL		= 0,
	HP_ITEM_CELL_MODE_SERIAL		= 1,
	HP_ITEM_CELL_MODE_DATE_CREATED	= 2
};

@implementation ItemAccessoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		// Create a subview - don't need to specify its position / size
		valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		
		// Put it on the content view of the cell
		[[self contentView] addSubview:valueLabel];
		
		// It is being retained by its superview
		[valueLabel release];
		
		// Same thing with the name
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:nameLabel];
		[nameLabel release];
		
		serialLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:serialLabel];
		[serialLabel release];
		
		dateCreatedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:dateCreatedLabel];
		[dateCreatedLabel release];
		
		accessoryViewMode = 0;
    }
    return self;
}

- (void)layoutSubviews
{
	// We always call this, the table view needs to do its own work first
	[super layoutSubviews];
	
	float inset = 5.0;
	CGRect bounds = [[self contentView] bounds];
	float h = bounds.size.height;
	float w = bounds.size.width;
	float valueWidth = 40.0;
	
	// Make a rectangle that is inset and roughly square
	CGRect innerFrame = CGRectMake(inset, inset, h - inset*2, w - inset*2);
	
	if (accessoryViewMode == HP_ITEM_CELL_MODE_SERIAL) {
		// Move that rectangle over and resize the width for the nameLabel
		innerFrame.size.width = w - (h + valueWidth * 4);
		[serialLabel setFrame:innerFrame];
		
		// Move that rectangle over again and resize the width for valueLabel
		innerFrame.origin.x += innerFrame.size.width + inset;
		innerFrame.size.width = valueWidth;
		[valueLabel setFrame:innerFrame];
	} else {
		// Move that rectangle over and resize the width for the nameLabel
		innerFrame.size.width = w - (h + valueWidth * 4);
		[nameLabel setFrame:innerFrame];
		
		// Move that rectangle over again and resize the width for valueLabel
		innerFrame.origin.x += innerFrame.size.width + inset;
		innerFrame.size.width = valueWidth;
		[valueLabel setFrame:innerFrame];
	}		
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)dealloc {
    [super dealloc];
}

- (void)setPossession:(Possession *)possession
{
	// Using a Possession instance, we can set the values of the subviews
	[valueLabel setText:
	 [NSString stringWithFormat:@"$%d", [possession valueInDollars]]];
	[nameLabel setText:[possession possessionName]];
	[serialLabel setText:[possession serialNumber]];
}

- (void)toggleCellAccessoryView
{
	if (accessoryViewMode == HP_ITEM_CELL_MODE_SERIAL)
		accessoryViewMode = HP_ITEM_CELL_MODE_DATE_CREATED;
	else
		accessoryViewMode = HP_ITEM_CELL_MODE_SERIAL;
}


@end
