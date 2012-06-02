//
//  AppController.h
//  iPing
//
//  Created by Marc Mauger on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSTextView *outputView;
	IBOutlet NSTextField *hostField;
	IBOutlet NSButton *startButton;
	NSTask *task;
	NSPipe *pipe;
}
- (IBAction)startStopPing:(id)sender;

@end
