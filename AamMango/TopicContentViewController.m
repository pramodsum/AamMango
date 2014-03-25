//
//  TopicContentViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/13/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "TopicContentViewController.h"
#import <OpenEars/OpenEarsLogging.h>

@interface TopicContentViewController ()

@end

@implementation TopicContentViewController {
    NSString *lmPath;
    NSString *dicPath;
    UIActivityIndicatorView *spinner;
    UIAlertView *alert;
//    OfflineRecognition *offlineRecognition;
}

@synthesize cardImage, cardLabel, cardEnglishLabel;
@synthesize card;
@synthesize player;
@synthesize playbackButton, recordButton;
@synthesize openEarsEventsObserver;

@synthesize pocketsphinxController;
@synthesize fliteController;
@synthesize usingStartLanguageModel;
@synthesize slt;
@synthesize restartAttemptsDueToPermissionRequests;
@synthesize startupFailedDueToLackOfPermissions;
@synthesize heardText;

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
    cardEnglishLabel.text = card.english;

    // Disable Stop/Play button when application launches
    [playbackButton setHidden:YES];

    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    //    offlineRecognition = [[OfflineRecognition alloc] initWithDeck:_deckArray];
    [OpenEarsLogging startOpenEarsLogging];
    [self.openEarsEventsObserver setDelegate:self];
}

- (void) createLanguageModel {
    LanguageModelGenerator *languageModelGenerator = [[LanguageModelGenerator alloc] init];
    NSString *myCorpus = [[NSBundle mainBundle] pathForResource:@"LanguageModelGeneratorLookupList" ofType:@"text"];
    NSString *name = @"hindi";
    NSError *err = [languageModelGenerator generateLanguageModelFromTextFile:myCorpus withFilesNamed:name forAcousticModelAtPath:@"AcousticModelHindi"];
    
    NSDictionary *languageGeneratorResults = nil;
    NSLog(@"err %@", err);

    if([err code] == noErr) {
        NSLog(@"err %@", err);

        languageGeneratorResults = [err userInfo];

        lmPath = [[NSBundle mainBundle] pathForResource:@"hindi" ofType:@"arpa"];
        dicPath = [[NSBundle mainBundle] pathForResource:@"hindi" ofType:@"dic"];

        NSLog(@"languageGeneratorResults: %@", languageGeneratorResults);
        
    } else {
        NSLog(@"\n--------------------\n--------------------\nError: %@",[err localizedDescription]);
    }
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


// Playback + Recording
- (IBAction)playback:(id)sender {
//    if (!recorder.recording){
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
//        [player setDelegate:self];
//        [player play];
//    }
//    else {
//        [recorder stop];
//    }
}

- (IBAction)record:(id)sender {
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }

    if (![self.pocketsphinxController isListening]) {
        [recordButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.pocketsphinxController startListeningWithLanguageModelAtPath:[[NSBundle mainBundle] pathForResource:@"hindi" ofType:@"gram"] dictionaryAtPath:[[NSBundle mainBundle] pathForResource:@"hindi" ofType:@"dic"] acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelHindi"] languageModelIsJSGF:YES];
        alert = [[UIAlertView alloc] initWithTitle:@"Calibrating..." message:@"\n"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];

        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(139.5, 75.5); // .5 so it doesn't blur
        [alert addSubview:spinner];
        [spinner startAnimating];
        [alert show];
    }else if([self.pocketsphinxController isSuspended]) {
        [recordButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.pocketsphinxController resumeRecognition];
    }else {
        [recordButton setTitle:@"Speak" forState:UIControlStateNormal];
        [self.pocketsphinxController suspendRecognition];
    }
//    [self.pocketsphinxController startListeningWithLanguageModelAtPath:[[NSBundle mainBundle] pathForResource:@"hindi" ofType:@"arpa"] dictionaryAtPath:[[NSBundle mainBundle] pathForResource:@"hindi" ofType:@"dic"] acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelHindi"] languageModelIsJSGF:NO];

}

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {

	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID); // Log it.

	self.heardText = [NSString stringWithFormat:@"Heard: \"%@\"", hypothesis]; // Show it in the status box.

	// This is how to use an available instance of FliteController. We're going to repeat back the command that we heard with the voice we've chosen.
//	[self.fliteController say:[NSString stringWithFormat:@"You said %@",hypothesis] withVoice:self.slt];

    NSString *message = [NSString stringWithFormat:@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID];
    NSLog(@"%@", message);

//    alert = [[UIAlertView alloc] initWithTitle: @"Hypothesis"
//                                                    message: message
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    [self checkPronunciationCorrectness:hypothesis recognitionScore:recognitionScore utteranceID:utteranceID];
}

- (void)checkPronunciationCorrectness:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {

//    [alert dismissWithClickedButtonIndex:0 animated:YES];

    if([hypothesis isEqual:card.translit]) {
        NSString *message = [NSString stringWithFormat:@"You said %@ correctly!", card.hindi];
        alert = [[UIAlertView alloc] initWithTitle: @"Correct!"
                                           message: message
                                          delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    } else {
        NSString *message = [NSString stringWithFormat:@"Sounds like you said %@ instead. Try again!", hypothesis];
        alert = [[UIAlertView alloc] initWithTitle: @"Wrong!"
                                           message: message
                                          delegate: nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
}

// OpenEars
- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}

- (void) getSpeech {
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
}

// Lazily allocated PocketsphinxController.
- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
        pocketsphinxController.verbosePocketSphinx = TRUE; // Uncomment me for verbose debug output
        pocketsphinxController.outputAudio = TRUE;
#ifdef kGetNbest
        pocketsphinxController.returnNbest = TRUE;
        pocketsphinxController.nBestNumber = 5;
#endif
	}
	return pocketsphinxController;
}

// Lazily allocated slt voice.
- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

// Lazily allocated FliteController.
- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];

	}
	return fliteController;
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    alert = [[UIAlertView alloc] initWithTitle:@"Begin!" message:@""
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    [alert show];
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
    alert = [[UIAlertView alloc] initWithTitle:@"Speech Detected" message:@""
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    [alert show];

}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [recordButton setTitle:@"Speak" forState:UIControlStateNormal];
//    [self.pocketsphinxController suspendRecognition];
//    alert = [[UIAlertView alloc] initWithTitle:@"Processing Speech..." message:@""
//                                      delegate:self
//                             cancelButtonTitle:nil
//                             otherButtonTitles:nil];
//    [alert show];
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

//- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
//	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
//}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    alert = [[UIAlertView alloc] initWithTitle:@"Setup Failed"
                                       message:@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more."
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    [alert show];
}

- (void) testRecognitionCompleted {
	NSLog(@"A test file that was submitted for recognition is now complete.");
}

@end
