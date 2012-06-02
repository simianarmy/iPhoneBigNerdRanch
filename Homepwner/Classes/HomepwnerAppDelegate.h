//
//  HomepwnerAppDelegate.h
//  Homepwner
//
//  Created by Marc Mauger on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemsViewController;

@interface HomepwnerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ItemsViewController *itemsViewController;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSString *)possessionArrayPath;
- (void)archivePossessions;
@end

