//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Marc Mauger on 12/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Possession;
@interface HomepwnerItemCell : UITableViewCell {
	UILabel *valueLabel;
	UILabel *nameLabel;
	UIImageView *imageView;
	Possession *possession;
	BOOL detailsMode;
	float valueWidth;
}

- (void)setPossession:(Possession *)possession;
- (void)accessoryButtonTapped;
- (void)setNameLabel:(NSString *)name valueLabel:(NSString *)value;
@end
