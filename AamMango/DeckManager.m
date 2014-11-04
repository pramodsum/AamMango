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
    BOOL loadedDeck;
}

- (BOOL) isDeckLoaded {
    return loadedDeck;
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

    NSLog(@"got here");

    PFQuery *query = [PFQuery queryWithClassName:@"Cards"];
    [query whereKey:@"category" equalTo:category];
    [query orderByAscending:@"createdAt"];

    loadedDeck = false;

    NSArray *results = [query findObjects];
    
    NSSortDescriptor *order = [[NSSortDescriptor alloc] initWithKey:@"orderInCol" ascending:YES];
    NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"english" ascending:YES];
    NSArray *sortedResults = [results sortedArrayUsingDescriptors:@[order, name]];
    
    for(PFObject *obj in sortedResults) {
        Card *c = [[Card alloc] init];
        c.english = [obj objectForKey:@"english"];
        c.hindi = [obj objectForKey:@"hindi"];
        c.translit = [obj objectForKey:@"translit"];
        c.orderInCol = [obj objectForKey:@"orderInCol"];
        c.synthesizer = [[AVSpeechSynthesizer alloc] init];
        [deck addCard:c];
        [deckArray addObject:c.hindi];
    }

    loadedDeck = true;
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
