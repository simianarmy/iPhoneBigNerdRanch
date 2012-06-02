//
//  RowControlsController.h
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"

@interface RowControlsController : SecondLevelViewController {
	NSArray *list;
}
@property (nonatomic, retain) NSArray *list;
- (IBAction)buttonTapped:(id)sender;

@end
