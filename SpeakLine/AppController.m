//
//  AppController.m
//  SpeakLine
//
//  Created by Marc Mauger on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController
- (id)init
{
	[super init];
	
	NSLog(@"init");
	
	speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
	[speechSynth setDelegate:self];
	voiceList = [[NSSpeechSynthesizer availableVoices] retain];
	return self;
}

- (IBAction)sayIt:(id)sender
{
	NSString *string = [textField stringValue];
	
	if ([string length] == 0) {
		NSLog(@"strong from %@ is zero-length, dog!", textField);
		return;
	}
	[speechSynth startSpeakingString:string];
	NSLog(@"Have started to say: %@", string);
	[stopButton setEnabled:YES];
	[startButton setEnabled:NO];
	[tableView setEnabled:NO];
}

- (IBAction)stopIt:(id)sender
{
	NSLog(@"stopping");
	[speechSynth stopSpeaking];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender
		didFinishSpeaking:(BOOL)complete
{
	NSLog(@"complete = %d", complete);
	[stopButton setEnabled:NO];
	[startButton setEnabled:YES];
	[tableView setEnabled:YES];
}

- (int)numberOfRowsInTableView:(NSTableView *)tv
{
	return [voiceList count];
}

- (id)tableView:(NSTableView *)tv
objectValueForTableColumn:(NSTableColumn *)tableColumn
			row:(int)row
{
	NSString *v = [voiceList objectAtIndex:row];
	NSDictionary *dict = [NSSpeechSynthesizer attributesForVoice:v];
	return [dict objectForKey:NSVoiceName];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
	int row = [tableView selectedRow];
	if (row == -1) {
		return;
	}
	NSString *selectedVoice = [voiceList objectAtIndex:row];
	[speechSynth setVoice:selectedVoice];
	NSLog(@"new voice = %@", selectedVoice);
}

- (void)awakeFromNib
{
	NSString *defaultVoice = [NSSpeechSynthesizer defaultVoice];
	int defaultRow = [voiceList indexOfObject:defaultVoice];
	[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:defaultRow] 
		   byExtendingSelection:NO];
	[tableView scrollRowToVisible:defaultRow];
}
@end
