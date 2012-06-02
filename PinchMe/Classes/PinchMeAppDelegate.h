//
//  PinchMeAppDelegate.h
//  PinchMe
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 Simian Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PinchMeViewController;

@interface PinchMeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PinchMeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PinchMeViewController *viewController;

@end

