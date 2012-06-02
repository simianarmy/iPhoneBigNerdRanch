//
//  HomepwnerItemAccessoryCell.m
//  Homepwner
//
//  Created by Marc Mauger on 12/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomepwnerItemAccessoryCell.h"


@implementation HomepwnerItemAccessoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
