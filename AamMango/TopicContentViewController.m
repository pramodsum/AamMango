//
//  TopicContentViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/13/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "TopicContentViewController.h"
#import "AppDelegate.h"

@interface TopicContentViewController ()

@end

@implementation TopicContentViewController {
    NSString *lmPath;
    NSString *dicPath;
    UIActivityIndicatorView *spinner;
    UIAlertView *alert;
    NSString *filePath;
    NSInteger fileNumber;

    AVAudioSession *audioSession;
    AVAudioRecorder *recorder;
    
    AppDelegate *appDelegate;
    PocketsphinxController *PSController;
}

@synthesize cardImage, cardLabel, cardEnglishLabel;
@synthesize card;
@synthesize player;
@synthesize recordButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cardImage.image = [UIImage imageNamed:card.english];
    UIFont *font = [UIFont fontWithName:@"DevanagariSangamMN" size:30];
    cardLabel.font = font;

    NSLog(@"HINDI: %@", card.hindi);
    cardLabel.text = card.hindi;
    cardEnglishLabel.text = card.english;

    fileNumber = 0;
    filePath = [NSString stringWithFormat:@"%@/audio", [self applicationDocumentsDirectory].path];
    
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PSController = [appDelegate pocketsphinxController];
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
    else {
        [card pronounce];
    }
}

- (IBAction)record:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }

    if ([PSController isSuspended]) {
        [PSController resumeRecognition];
    } else {
        [PSController suspendRecognition];
    }

}

@end
