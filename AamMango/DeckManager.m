//
//  DeckManager.m
//  AamMango
//
//  Created by Sumedha Pramod on 3/11/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "DeckManager.h"

@implementation DeckManager {
    Deck *deck;
    NSMutableArray *deckArray;
}

- (Deck *) getDeck {
    return deck;
}

- (NSUInteger) count {
    return [deck count];
}

- (Card *) getCard:(NSUInteger) index {
    return [deck fetch:index];
}

- (Deck *) fetchDeck:(NSString *) category {
    if([deck count] == 0) {
        deck = [[Deck alloc] init];
        deckArray = [[NSMutableArray alloc] init];
    }

    PFQuery *query = [PFQuery queryWithClassName:@"Cards"];
    [query whereKey:@"category" equalTo:category];
    [query orderByAscending:@"createdAt"];

    NSArray *results = query.findObjects;

    for(PFObject *obj in results) {
        Card *c = [[Card alloc] init];
        c.english = [obj objectForKey:@"english"];
        c.hindi = [obj objectForKey:@"hindi"]; 
        c.translit = [obj objectForKey:@"translit"];
        c.synthesizer = [[AVSpeechSynthesizer alloc] init];
        [deck addCard:c];
        [deckArray addObject:c.hindi];
    }
    [query cancel];
    return deck;
}

- (Deck *) changeDeck:(NSString *) category {
    if([deck count] > 0) {
        [deck clearDeck];
    }
    [self fetchDeck:category];
    return deck;
}

- (NSArray *) getDeckArray {
    return deckArray;
}

@end
