//
//  Deck.h
//  AamMango
//
//  Created by Sumedha Pramod on 3/4/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "Card.h"
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Deck : NSObject

@property (strong, nonatomic) NSMutableArray *cards;

- (void) initDeck:(NSString *)category;

@end
