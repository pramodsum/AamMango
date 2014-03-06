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
    cardImage.image = [UIImage imageNamed:card.english];
    UIFont *font = [UIFont fontWithName:@"DevanagariSangamMN" size:30];
    cardLabel.font = font;

    //Get Hindi Translation of english word
    [[MSTranslateAccessTokenRequester sharedRequester] requestSynchronousAccessToken:CLIENT_ID clientSecret:CLIENT_SECRET];

    //Get Hindi translation if not already found
    if(card.hindi.length == 0) {
        MSTranslateVendor *vendor = [[MSTranslateVendor alloc] init];
        [vendor requestTranslate: card.english from:@"en" to:@"hi" blockWithSuccess:
         ^(NSString *translatedText) {
             NSLog(@"translatedText: %@", translatedText);
             card.hindi = translatedText;
             cardLabel.text = translatedText;
         }
                         failure:^(NSError *error) {
                             NSLog(@"error_translate: %@", error);
                         }];
        NSLog(@"hindi: %@", card.hindi);
    }
    cardLabel.text = card.hindi;
    cardHindiLabel.text = card.translit;
    cardEnglishLabel.text = card.english;
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
    else {
        [card pronounce];
    }
}

@end
