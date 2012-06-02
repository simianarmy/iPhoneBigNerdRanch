//
//  PresidentsViewController.h
//  Nav
//
//  Created by Marc Mauger on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondLevelViewController.h"

@interface PresidentsViewController : SecondLevelViewController {
	NSMutableArray *list;
}
@property (nonatomic, retain) NSMutableArray *list;

@end
