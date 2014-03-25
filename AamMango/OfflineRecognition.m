//
//  OfflineRecognition.m
//  AamMango
//
//  Created by Sumedha Pramod on 3/16/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "OfflineRecognition.h"
#import "Deck.h"

@implementation OfflineRecognition {
    LanguageModelGenerator *lmGenerator;
    NSString *lmPath;
    NSString *dicPath;
    NSArray *deck;
}

@synthesize pocketsphinxController;
@synthesize fliteController;
@synthesize openEarsEventsObserver;
@synthesize usingStartLanguageModel;
@synthesize slt;
@synthesize restartAttemptsDueToPermissionRequests;
@synthesize startupFailedDueToLackOfPermissions;
@synthesize heardText;

- (OfflineRecognition *) initWithDeck:(NSArray *) currentDeck {
    self.restartAttemptsDueToPermissionRequests = 0;
    self.startupFailedDueToLackOfPermissions = FALSE;

    deck = [[NSArray alloc] init];
    deck = currentDeck;

    //[OpenEarsLogging startOpenEarsLogging]; // Uncomment me for OpenEarsLogging
    [self createLanguageModel];

    // Next, an informative message.

//	NSLog(@"\n\nWelcome to the OpenEars sample project. This project understands the words:\nBACKWARD,\nCHANGE,\nFORWARD,\nGO,\nLEFT,\nMODEL,\nRIGHT,\nTURN,\nand if you say \"CHANGE MODEL\" it will switch to its dynamically-generated model which understands the words:\nCHANGE,\nMODEL,\nMONDAY,\nTUESDAY,\nWEDNESDAY,\nTHURSDAY,\nFRIDAY,\nSATURDAY,\nSUNDAY,\nQUIDNUNC");

    return self;
}

- (void) createLanguageModel {
    NSLog(@"Deck size: %lu", deck.count);
//    NSError *err = [lmGenerator
//                    generateLanguageModelFromArray:deck
//                    withFilesNamed:@"OpenEarsDynamicGrammar"
//                    forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelHindi"]];
//
//    NSDictionary *languageGeneratorResults = nil;
//
//    lmPath = nil;
//    dicPath = nil;
//
//    if([err code] == noErr) {
//
//        languageGeneratorResults = [err userInfo];
//
//        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
//        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
//		
//    } else {
//        NSLog(@"Error: %@",[err localizedDescription]);
//    }
    NSArray *words = [NSArray arrayWithObjects:@"WORD", @"STATEMENT", @"OTHER WORD", @"A PHRASE", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    NSDictionary *languageGeneratorResults = nil;

    if([err code] == noErr) {

        languageGeneratorResults = [err userInfo];

        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];

    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }
}

- (void) getSpeech {
    [self.pocketsphinxController
     startListeningWithLanguageModelAtPath:lmPath
     dictionaryAtPath:dicPath
     acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelHindi"]
     languageModelIsJSGF:NO];
}

// Lazily allocated PocketsphinxController.
- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
        //pocketsphinxController.verbosePocketSphinx = TRUE; // Uncomment me for verbose debug output
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

@end
