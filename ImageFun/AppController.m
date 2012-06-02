//
//  AppController.m
//  ImageFun
//
//  Created by Marc Mauger on 10/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "StretchView.h"

@implementation AppController

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel
			 returnCode:(int)returnCode
			contextInfo:(void *)x
{
	// Did they choose "Open"?
	if (returnCode == NSOKButton) {
		NSString *path = [openPanel filename];
		NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
		[stretchView setImage:image];
		[image release];
	}
}

- (IBAction)showOpenPanel:(id)sender
{
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	// Run the open panel
	[panel beginSheetForDirectory:nil 
							 file:nil
							types:[NSImage imageFileTypes]
				   modalForWindow:[stretchView window]
					modalDelegate:self 
				   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
					  contextInfo:NULL];
}

@end
