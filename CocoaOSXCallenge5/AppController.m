//
//  AppController.m
//  CocoaOSXCallenge5
//
//  Created by Marc Mauger on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (IBAction)doCount:(id)sender
{
	NSString *string = [textField stringValue];
	int strLen = [string length];
	NSString *wordCountString;
	wordCountString = [NSString stringWithFormat:@"'%@' has %d characters, dog.", 
					   string, strLen];
	[wordCountField setStringValue:wordCountString];
}
@end
