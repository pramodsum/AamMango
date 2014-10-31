//
//  DeckManager.h
//  AamMango
//
//  Created by Sumedha Pramod on 3/11/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface DeckManager : NSObject

- (NSArray *) getDeckArray;
- (BOOL) isDeckLoaded;
- (Deck *) fetchDeck:(NSString *) category;
- (Deck *) changeDeck:(NSString *) category;


- (Card *) getCard:(NSUInteger) index;
- (Deck *) getDeck;
- (NSUInteger) count;

@end
