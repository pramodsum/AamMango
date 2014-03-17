//
//  TopicContentViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/13/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "TopicContentViewController.h"

@interface TopicContentViewController ()

@end

@implementation TopicContentViewController {
    AVAudioRecorder *recorder;
}

@synthesize cardImage, cardLabel, cardEnglishLabel, cardHindiLabel;
@synthesize card;
@synthesize player;
@synthesize playbackButton, recordButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cardImage.image = [UIImage imageNamed:card.english];
    UIFont *font = [UIFont fontWithName:@"DevanagariSangamMN" size:30];
    cardLabel.font = font;

    NSLog(@"HINDI: %@", card.hindi);
    cardLabel.text = card.hindi;
    cardHindiLabel.text = card.translit;
    cardEnglishLabel.text = card.english;

    // Disable Stop/Play button when application launches
    [playbackButton setHidden:YES];

    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];

    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];

    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];

    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pronounceWord:(id)sender {
    if([card.hindi isEqual:@""]) {
        [card announceError];
    }
    else if(player.playing) {
        [player stop];
    }
    else if(recorder.recording) {
        [recorder stop];
    }
    else {
        [card pronounce];
    }
}

- (IBAction)playback:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
    else {
        [recorder stop];
    }
}

- (IBAction)record:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }

    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];

        // Start recording
        [recorder record];
        [recordButton setTitle:@"Done" forState:UIControlStateNormal];

    } else {

        // Stop recording
        [recorder stop];

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
    }
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [recordButton setTitle:@"Repeat" forState:UIControlStateNormal];

    [playbackButton setHidden:NO];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
}

@end
