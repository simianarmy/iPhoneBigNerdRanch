//
//  AppController.h
//  TypingTutor
//
//  Created by Marc Mauger on 10/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class BigLetterView;

@interface AppController : NSObject {
	// Outlets
	IBOutlet BigLetterView *inLetterView;
	IBOutlet BigLetterView *outLetterView;
	
	// Data
	NSArray *letters;
	int lastIndex;
	
	// Time
	NSTimer *timer;
	int count;
}
- (IBAction)stopGo:(id)sender;
- (void)incrementCount;
- (void)resetCount;
- (void)showAnotherLetter;

@end
