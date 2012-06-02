//
//  BallAppDelegate.h
//  Ball
//
//  Created by Marc Mauger on 7/17/11.
//  Copyright 2011 Simian Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BallViewController;

@interface BallAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BallViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BallViewController *viewController;

@end

