//
//  SwipesAppDelegate.h
//  Swipes
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwipesViewController;

@interface SwipesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SwipesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SwipesViewController *viewController;

@end

