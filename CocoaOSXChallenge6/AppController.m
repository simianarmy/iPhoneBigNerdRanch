//
//  AppController.m
//  CocoaOSXChallenge6
//
//  Created by Marc Mauger on 8/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController
- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
	NSLog(@"window will resize to %f x %f", frameSize.width, frameSize.height);
	NSSize theSize;
	theSize.width = frameSize.width;
	theSize.height = frameSize.width * 2;
	return theSize;
}
@end
