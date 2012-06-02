//
//  MoveMeController.h
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"

@interface MoveMeController : SecondLevelViewController {
	NSMutableArray *list;
}
@property (nonatomic, retain) NSMutableArray *list;
-(IBAction)toggleMove;

@end
