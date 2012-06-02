//
//  TouchTrackerAppDelegate.h
//  TouchTracker
//
//  Created by Marc Mauger on 12/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchDrawView;
@interface TouchTrackerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet TouchDrawView *touchDrawView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end

