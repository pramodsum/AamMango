//
//  Deck.m
//  AamMango
//
//  Created by Sumedha Pramod on 3/4/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "Deck.h"

@implementation Deck

@synthesize cards;

- (void) initDeck:(NSString *)category {

    PFQuery *query = [PFQuery queryWithClassName:@"Cards"];
    [query whereKey:@"category" equalTo:category];
    [query orderByAscending:@"createdAt"];

    NSArray *results = query.findObjects;
    cards = [[NSMutableArray alloc] init];

    for(PFObject *obj in results) {
        Card *c = [[Card alloc] init];
        c.english = [obj objectForKey:@"english"];
        c.translit = [obj objectForKey:@"translit"];
        c.pfimage.file = [obj objectForKey:@"image"];
        [cards addObject:c];
        c.synthesizer = [[AVSpeechSynthesizer alloc] init];
    }

    [query cancel];
}

@end
