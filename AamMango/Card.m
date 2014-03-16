//
//  Card.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "Card.h"
#import <Parse/PFObject+Subclass.h>

@implementation Card 

@synthesize answeredCorrectly, synthesizer, english, hindi, translit, category;

-(BOOL) isAnsweredCorrectly {
    if (answeredCorrectly) {
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString: @"Correct!"];
        [synthesizer speakUtterance:utterance];
        return YES;
    }
    return NO;
}

-(void) pronounce {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString: self.hindi];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"hi-IN"];
    [synthesizer speakUtterance:utterance];
}

-(void) pronounceString:(NSString *) str {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString: str];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"hi-IN"];
    [synthesizer speakUtterance:utterance];
}

-(void) announceError {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString: @"I'm sorry! There was an error in the application. Please report this bug."];
    [synthesizer speakUtterance:utterance];
}

@end
