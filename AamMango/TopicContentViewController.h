//
//  TopicContentViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/13/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <OpenEars/OpenEarsEventsObserver.h>
#import "OfflineRecognition.h"
#import <UIKit/UIKit.h>
#import "Card.h"
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/AcousticModel.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@class PocketsphinxController;
@class FliteController;

@interface TopicContentViewController : UIViewController <OpenEarsEventsObserverDelegate, AVAudioRecorderDelegate> {
    OpenEarsEventsObserver *openEarsEventsObserver;
	Slt *slt;

	// These three are important OpenEars classes that ViewController demonstrates the use of. There is a fourth important class (LanguageModelGenerator) demonstrated
	// inside the ViewController implementation in the method viewDidLoad.

	PocketsphinxController *pocketsphinxController; // The controller for Pocketsphinx (voice recognition).
	FliteController *fliteController; // The controller for Flite (speech).

	// Some UI, not specifically related to OpenEars.
	BOOL usingStartLanguageModel;
	int restartAttemptsDueToPermissionRequests;
    BOOL startupFailedDueToLackOfPermissions;
}

// These three are the important OpenEars objects that this class demonstrates the use of.
@property (nonatomic, strong) Slt *slt;

@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;
@property (nonatomic, strong) FliteController *fliteController;

@property (nonatomic, assign) BOOL usingStartLanguageModel;
@property (nonatomic, assign) int restartAttemptsDueToPermissionRequests;
@property (nonatomic, assign) BOOL startupFailedDueToLackOfPermissions;

@property (nonatomic, assign) NSString *heardText;

- (void) createLanguageModel;
- (void) getSpeech;

@property (strong, nonatomic) IBOutlet PFImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *cardLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardEnglishLabel;
@property (strong, nonatomic) Card *card;

@property AVAudioPlayer *player;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *subtitleText;
@property NSString *imageFile;

@property NSArray *deckArray;

@property (strong, nonatomic) IBOutlet UIButton *playbackButton;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;

- (IBAction)pronounceWord:(id)sender;
- (IBAction)playback:(id)sender;
- (IBAction)record:(id)sender;

@end
