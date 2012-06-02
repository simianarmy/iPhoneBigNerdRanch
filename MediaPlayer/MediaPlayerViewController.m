//
//  MediaPlayerViewController.m
//  MediaPlayer
//
//  Created by Marc Mauger on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MediaPlayerViewController.h"


@implementation MediaPlayerViewController

- (id)init
{
	self = [super initWithNibName:@"MediaPlayerViewController" bundle:nil];
	
	NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Layers"
														  ofType:@"m4v"];
	if (moviePath) {
		NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
		moviePlayer = [[MPMoviePlayerController alloc]
					   initWithContentURL:movieURL];
	}
	NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"Music"
														  ofType:@"mp3"];
	if (musicPath) {
		NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
		[[AVAudioSession sharedInstance]
		 setCategory:AVAudioSessionCategoryPlayback error:nil];
		audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];

		[audioPlayer setDelegate:self];
	}
	// Get the full path of Sound12.aif
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Sound12"
														   ofType:@"aif"];
	// If this file is actually in the bundle...
	if (soundPath) {
		// Create a file URL with this path
		NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
		
		// Register sound file as a system sound
		OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundURL, &shortSound);
		
		if (err != kAudioServicesNoError) {
			NSLog(@"Could not load %@, error code: %d", soundURL, err);
		}
	}
	// Setup the audio recorder object
	// Get path to app's data directory
	NSString *recordingPath = pathInDocumentDirectory(@"audiorecording.caf");
	if (recordingPath) {
		[[AVAudioSession sharedInstance]
		 setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
		
		NSURL *recordingURL = [NSURL fileURLWithPath:recordingPath];
		NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
		[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
		
		[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
		[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
		[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
		
		
		NSError *error;
		audioRecorder = [[AVAudioRecorder alloc] initWithURL:recordingURL 
													settings:recordSetting
													   error:&error];
		if (error) {
			NSLog(@"Could not load %@, error: %@", recordingURL, error);
		} else {
			[audioRecorder setDelegate:self];
			[audioRecorder prepareToRecord]; // Speeds up recording state
		}
		[recordSetting release];
	}
	return self;
}
	
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self init];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
	[[self view] addSubview:[moviePlayer view]];
	float halfHeight = [[self view] bounds].size.height / 2.0;
	float width = [[self view] bounds].size.width;
	[[moviePlayer view] setFrame:CGRectMake(0, halfHeight, width, halfHeight)];
	[playRecordingButton setEnabled:NO];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[moviePlayer release];
	moviePlayer = nil;
	[audioPlayer release];
	audioPlayer = nil;
	[audioRecorder release];
	audioRecorder = nil;
}


- (void)dealloc {
	// Delete any previous recordings
	[audioRecorder deleteRecording];
	[moviePlayer release];
	[audioPlayer release];
	[audioRecorder release];
    [super dealloc];
}

- (IBAction)playAudioFile:(id)sender
{
	if ([audioPlayer isPlaying]) {
		// Stop playing audio and change text of button
		[audioPlayer stop];
		[sender setTitle:@"Play Audio File"
				forState:UIControlStateNormal];
	} else {
		[audioPlayer play];
		[sender setTitle:@"Stop Audio File"
				forState:UIControlStateNormal];
	}
}

- (IBAction)playShortSound:(id)sender
{
	AudioServicesPlaySystemSound(shortSound);
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (IBAction)recordAudio:(id)sender
{
	NSLog(@"RecordingAudio");
	
	// Get recording state
	if ([audioRecorder isRecording] == YES) {
		[audioRecorder stop];
		[playRecordingButton setEnabled:YES];
		[recordAudioButton setTitle:@"Record Audio" forState:UIControlStateNormal];
	} else {
		if ([audioRecorder record]) {
			[recordAudioButton setTitle:@"Stop Recording" forState:UIControlStateNormal];
			[playRecordingButton setEnabled:NO];
		} else {
			NSLog(@"Recording failed to start!?");
		}
	}
}

- (IBAction)playRecording:(id)sender
{
	NSError *err;
	AVAudioPlayer *p = [[AVAudioPlayer alloc]
						initWithContentsOfURL:[audioRecorder url] 
										error:&err];
	if (err) {
		NSLog(@"Error initializing recording playback: %@", err);
		return;
	}
	if ([p play]) {
		NSLog(@"playing recording...");
	} else {
		NSLog(@"Could not play back recording!?");
	}
	
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[audioButton setTitle:@"Play Audio File" forState:UIControlStateNormal];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	[audioPlayer play];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder 
						   successfully:(BOOL)flag
{
	NSLog(@"audio recording status: %d", flag);
	if (flag == YES) {
		[playRecordingButton setEnabled:YES];
		[playRecordingButton setHighlighted:YES];
	} else {
		[recordAudioButton setTitle:@"Record Audio" forState:UIControlStateNormal];
	}
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder 
								   error:(NSError *)error
{
	NSLog(@"recording failed! %@", error);
	[recordAudioButton setTitle:@"Start Recording" forState:UIControlStateNormal];
}


@end
