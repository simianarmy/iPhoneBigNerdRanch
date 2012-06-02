//
//  AppController.m
//  iPing
//
//  Created by Marc Mauger on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"


@implementation AppController

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

- (IBAction)startStopPing:(id)sender
{
	// Is the task running?
	if (task) {
		[task interrupt];
	} else {
		task = [[NSTask alloc] init];
		[task setLaunchPath:@"/sbin/ping"];
		
		NSArray *args = [NSArray arrayWithObjects:@"-c10",
						 [hostField stringValue], nil];
		[task setArguments:args];
		
		// Release the old pipe
		[pipe release];
		// Create a new pipe
		pipe = [[NSPipe alloc] init];
		[task setStandardOutput:pipe];
		
		NSFileHandle *fh = [pipe fileHandleForReading];
		
		NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self];
		[nc addObserver:self
			   selector:@selector(dataReady:)
				   name:NSFileHandleReadCompletionNotification
				 object:fh];
		[nc addObserver:self
			   selector:@selector(taskTerminated:)
				   name:NSTaskDidTerminateNotification
				 object:task];
		[task launch];
		[outputView setString:@""];
		
		[fh readInBackgroundAndNotify];
	}
}

- (void)appendData:(NSData *)d
{
	NSString *s = [[NSString alloc] initWithData:d
										encoding:NSUTF8StringEncoding];
	NSTextStorage *ts = [outputView textStorage];
	[ts replaceCharactersInRange:NSMakeRange([ts length], 0)
					  withString:s];
	[s release];
}

- (void)dataReady:(NSNotification *)n
{
	NSData *d;
	d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
	
	NSLog(@"dataReady:%d bytes", [d length]);
	
	if ([d length]) {
		[self appendData:d];
	}
	// If the task is running, start reading again
	if (task)
		[[pipe fileHandleForReading] readInBackgroundAndNotify];
}

- (void)taskTerminated:(NSNotification *)note
{
	NSLog(@"taskTerminated");
	
	[task release];
	task = nil;
	
	[startButton setState:0];
}

@end
