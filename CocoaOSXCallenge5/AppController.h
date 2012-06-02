//
//  AppController.h
//  CocoaOSXCallenge5
//
//  Created by Marc Mauger on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppController : NSObject {
	IBOutlet NSTextField *textField;
	IBOutlet NSTextField *wordCountField;
}
- (IBAction)doCount:(id)sender;

@end
