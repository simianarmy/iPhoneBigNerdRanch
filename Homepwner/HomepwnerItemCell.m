//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Marc Mauger on 12/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomepwnerItemCell.h"
#import "Possession.h"

enum {
	HP_ITEM_CELL_MODE_NORMAL		= 0,
	HP_ITEM_CELL_MODE_SERIAL		= 1,
};

@implementation HomepwnerItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    
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
		[nameLabel setAdjustsFontSizeToFitWidth:YES];
		[[self contentView] addSubview:nameLabel];
		[nameLabel release];
		
		// Same thing with the image view
		imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:imageView];
		[imageView release];
		
		detailsMode = NO;
		valueWidth = 40.0;
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

	// Make a rectangle that is inset and roughly square
	CGRect innerFrame = CGRectMake(inset, inset, h, h - inset * 2.0);
	[imageView setFrame:innerFrame];
	
	// Move that rectangle over and resize the width for the nameLabel
	innerFrame.origin.x += innerFrame.size.width + inset;
	innerFrame.size.width = w - (h + valueWidth * 4);
	[nameLabel setFrame:innerFrame];
	
	// Move that rectangle over again and resize the width for valueLabel
		
	innerFrame.origin.x += innerFrame.size.width + inset;
	// hack: 
	// Check value width to determine what data is being displayed.
	// 40 = normal, other = details view.
	if (valueWidth == 40.0)
		innerFrame.size.width = valueWidth;
	else
		innerFrame.size.width = valueWidth + 60;
	
	[valueLabel setFrame:innerFrame];
}
	
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

	
- (void)dealloc {
    [super dealloc];
}

- (void)accessoryButtonTapped
{
	if (detailsMode == TRUE) {
		NSLog(@"Setting normal mode data");
		valueWidth = 40.0;
		[self layoutSubviews];	
		// Using a Possession instance, we can set the values of the subviews
		[self setNameLabel:[possession possessionName] valueLabel:
		 [NSString stringWithFormat:@"$%d", [possession valueInDollars]]];
	} else {
		// Set labels to serial & date, hide image
		NSLog(@"Setting accessory mode data");
		valueWidth = 30;
		[self layoutSubviews];	
		[self setNameLabel:[possession serialNumber] valueLabel:
			 [NSDateFormatter 
			  localizedStringFromDate:[possession dateCreated] 
			  dateStyle:kCFDateFormatterShortStyle
			  timeStyle:kCFDateFormatterNoStyle]]; 
	}
	detailsMode = !detailsMode;
}

- (void)setPossession:(Possession *)apossession
{
	// Copy possession object
	if (apossession != possession) {
		[apossession retain];
		[possession release];
		possession = apossession;
	}
	// Using a Possession instance, we can set the values of the subviews
	[self setNameLabel:[possession possessionName] valueLabel:
	 [NSString stringWithFormat:@"$%d", [possession valueInDollars]]];

	[imageView setImage:[apossession thumbnail]];
}


- (void)setNameLabel:(NSString *)name valueLabel:(NSString *)value
{
	[nameLabel setText:name];
	[valueLabel setText:value];
}
@end
