//
//  HypnosisterAppDelegate.h
//  Hypnosister
//
//  Created by Marc Mauger on 12/5/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hypnosister;

@interface HypnosisterAppDelegate : NSObject 
	<UIApplicationDelegate, UIScrollViewDelegate> {
    UIWindow *window;
	Hypnosister *view;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

