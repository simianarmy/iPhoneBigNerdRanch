//
//  TouchExplorerAppDelegate.h
//  TouchExplorer
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchExplorerViewController;

@interface TouchExplorerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TouchExplorerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TouchExplorerViewController *viewController;

@end

