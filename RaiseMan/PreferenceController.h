//
//  PreferenceController.h
//  RaiseMan
//
//  Created by Marc Mauger on 9/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const BNRTableBgColorKey;
extern NSString * const BNREmptyDocKey;
extern NSString * const BNRColorChangedNotification;

@interface PreferenceController : NSWindowController {
	IBOutlet NSColorWell *colorWell;
	IBOutlet NSButton *checkbox;
	IBOutlet NSButton *resetPreferences;
}
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeNewEmptyDoc:(id)sender;
- (IBAction)resetPreferences:(id)sender;
- (NSColor *)tableBgColor;
- (BOOL)emptyDoc;

@end
