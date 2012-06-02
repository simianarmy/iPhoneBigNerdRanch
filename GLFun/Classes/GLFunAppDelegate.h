//
//  GLFunAppDelegate.h
//  GLFun
//
//  Created by Marc Mauger on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLFunViewController;

@interface GLFunAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GLFunViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLFunViewController *viewController;

@end

