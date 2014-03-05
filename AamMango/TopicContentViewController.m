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

@implementation TopicContentViewController
@synthesize cardImage, cardLabel, cardEnglishLabel, cardHindiLabel;
@synthesize card;

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

    cardImage.image = [UIImage imageNamed:card.image];
    UIFont *font = [UIFont fontWithName:@"DevanagariSangamMN" size:30];
    cardLabel.font = font;
    cardLabel.text = card.hindi;
    cardHindiLabel.text = card.translit;
    cardEnglishLabel.text = card.english;

    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pronounceWord:(id)sender {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString: card.hindi];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"hi-IN"];
    [self.synthesizer speakUtterance:utterance];
}

@end
