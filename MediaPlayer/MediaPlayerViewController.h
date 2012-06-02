//
//  MediaPlayerViewController.h
//  MediaPlayer
//
//  Created by Marc Mauger on 12/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MediaPlayerViewController : UIViewController 
	<AVAudioPlayerDelegate, AVAudioRecorderDelegate> {
	IBOutlet UIButton *audioButton;
	IBOutlet UIButton *recordAudioButton;
	IBOutlet UIButton *playRecordingButton;
	SystemSoundID shortSound;
	
	AVAudioPlayer *audioPlayer;
	AVAudioRecorder *audioRecorder;
	MPMoviePlayerController *moviePlayer;
}
- (IBAction)playAudioFile:(id)sender;
- (IBAction)playShortSound:(id)sender;
- (IBAction)recordAudio:(id)sender;
- (IBAction)playRecording:(id)sender;

@end
