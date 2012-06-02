//
//  QuartzFunAppDelegate.h
//  QuartzFun
//
//  Created by Marc Mauger on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuartzFunViewController;

@interface QuartzFunAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    QuartzFunViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet QuartzFunViewController *viewController;

@end

