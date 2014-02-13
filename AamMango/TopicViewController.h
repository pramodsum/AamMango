//
//  TopicViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface TopicViewController : UIViewController

@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) NSArray *numberCards;
@property (strong, nonatomic) NSArray *fruitCards;
@property (strong, nonatomic) NSArray *vegetableCards;
@property (strong, nonatomic) NSArray *emotionCards;

@property (strong, nonatomic) IBOutlet UIImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *cardLabel;
@property (strong, nonatomic) Card *card;

@end
