//
//  AppController.h
//  SpeakLine
//
//  Created by Marc Mauger on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSTextField *textField;
	NSSpeechSynthesizer *speechSynth;
	IBOutlet NSButton *stopButton;
	IBOutlet NSButton *startButton;
	IBOutlet NSTableView *tableView;
	NSArray *voiceList;
}
- (IBAction)sayIt:(id)sender;
- (IBAction)stopIt:(id)sender;

@end
