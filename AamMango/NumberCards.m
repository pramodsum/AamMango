//
//  NumberCards.m
//  AamMango
//
//  Created by Sumedha Pramod on 3/4/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "NumberCards.h"
#import "Card.h"

@implementation NumberCards

@synthesize numberCards;

- (void) initNumberCards {
    Card *c1 = [[Card alloc] init],
        *c2 = [[Card alloc] init],
        *c3 = [[Card alloc] init],
        *c4 = [[Card alloc] init],
        *c5 = [[Card alloc] init],
        *c6 = [[Card alloc] init],
        *c7 = [[Card alloc] init],
        *c8 = [[Card alloc] init],
        *c9 = [[Card alloc] init],
        *c10 = [[Card alloc] init];

    c1.label = @"Ek";
    c1.image = @"number_one";
    c1.english = @"One";
    c1.hindi = @"एक";
    c1.translit = @"Ek";

    c2.label = @"Do";
    c2.image = @"number_two";
    c2.english = @"Two";
    c2.hindi = @"दो";
    c2.translit = @"Do";

    c3.label = @"Theen";
    c3.image = @"number_three";
    c3.english = @"Three";
    c3.hindi = @"तीन";
    c3.translit = @"Theen";

    c4.label = @"Chaar";
    c4.image = @"number_four";
    c4.english = @"Four";
    c4.hindi = @"चार";
    c4.translit = @"Chaar";

    c5.label = @"Paanch";
    c5.image = @"number_five";
    c5.english = @"Five";
    c5.hindi = @"पांच";
    c5.translit = @"Paanch";

    c6.label = @"Che";
    c6.image = @"number_six";
    c6.english = @"Six";
    c6.hindi = @"छे";
    c6.translit = @"Che";

    c7.label = @"Saath";
    c7.image = @"number_seven";
    c7.english = @"Seven";
    c7.hindi = @"साट";
    c7.translit = @"Saat";

    c8.label = @"Aat";
    c8.image = @"number_eight";
    c8.english = @"Eight";
    c8.hindi = @"आट";
    c8.translit = @"Aat";

    c9.label = @"Nau";
    c9.image = @"number_nine";
    c9.english = @"Nine";
    c9.hindi = @"नौ";
    c9.translit = @"Nau";

    c10.label = @"Dus";
    c10.image = @"number_ten";
    c10.english = @"Ten";
    c10.hindi = @"दस";
    c10.translit = @"Dus";

    numberCards = [[NSArray alloc]
                    initWithObjects: c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, nil];
}

@end
