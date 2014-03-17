//
//  OfflineRecognition.m
//  AamMango
//
//  Created by Sumedha Pramod on 3/16/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "OfflineRecognition.h"

@implementation OfflineRecognition {
    LanguageModelGenerator *lmGenerator;
    NSString *lmPath;
    NSString *dicPath;
}

@synthesize pocketsphinxController;

- (OfflineRecognition *) init {
    lmGenerator = [[LanguageModelGenerator alloc] init];
    return self;
}

- (void) createLanguageModel {
    NSArray *words = [NSArray arrayWithObjects:@"WORD", @"STATEMENT", @"OTHER WORD", @"A PHRASE", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    NSError *err = [lmGenerator
                    generateLanguageModelFromArray:words
                    withFilesNamed:name
                    forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelHindi"]];

    NSDictionary *languageGeneratorResults = nil;

    lmPath = nil;
    dicPath = nil;

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

- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}

@end
