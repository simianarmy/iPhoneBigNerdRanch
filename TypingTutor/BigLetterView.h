//
//  BigLetterView.h
//  TypingTutor
//
//  Created by Marc Mauger on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BigLetterView : NSView {
	NSColor *bgColor;
	NSString *string;
	NSMutableDictionary *attributes;
	NSShadow *shadow;
	NSEvent *mouseDownEvent;
	BOOL bold;
	BOOL italic;
	BOOL highlighted;
	IBOutlet NSButton *boldCheckbox;
	IBOutlet NSButton *italicCheckbox;
}
@property (retain, readwrite) NSColor *bgColor;
@property (copy, readwrite) NSString *string;
- (IBAction)savePDF:(id)sender;
- (IBAction)boldButtonPressed:(id)sender;
- (IBAction)italicButtonPressed:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;

@end
