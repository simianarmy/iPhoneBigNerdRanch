//
//  DeleteMeController.h
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"

@interface DeleteMeController : SecondLevelViewController {
	NSMutableArray *list;
}
@property (nonatomic, retain) NSMutableArray *list;
-(IBAction)toggleEdit:(id)sender;

@end
