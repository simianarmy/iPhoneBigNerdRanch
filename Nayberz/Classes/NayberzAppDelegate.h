//
//  NayberzAppDelegate.h
//  Nayberz
//
//  Created by Marc Mauger on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NayberzAppDelegate : NSObject 
	<UIApplicationDelegate, NSNetServiceDelegate> {
    UIWindow *window;
	NSNetService *netService;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)setMessage:(NSString *)str forNetService:(NSNetService *)service;

@end

