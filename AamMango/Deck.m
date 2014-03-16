//
//  Deck.m
//  AamMango
//
//  Created by Sumedha Pramod on 3/4/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "AppDelegate.h"
#import "Deck.h"

@implementation Deck {
    NSMutableArray *cards;
}

- (void) addCard:(Card *) c {
    if([cards count] == 0) {
        cards = [[NSMutableArray alloc] init];
    }
    [cards addObject:c];
}

- (NSArray *) getCards {
    return cards;
}

- (void) clearDeck {
    [cards removeAllObjects];
}

- (NSUInteger) count {
    return [cards count];
}

- (Card *) fetch:(NSUInteger) index {
    return [cards objectAtIndex:index];
}

@end
