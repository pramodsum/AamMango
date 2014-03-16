//
//  TopicContentViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/13/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface TopicContentViewController : UIViewController

@property (strong, nonatomic) IBOutlet PFImageView *cardImage;
@property (strong, nonatomic) IBOutlet UILabel *cardLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardEnglishLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardHindiLabel;
@property (strong, nonatomic) Card *card;

@property AVAudioPlayer *player;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *subtitleText;
@property NSString *imageFile;

- (IBAction)pronounceWord:(id)sender;

@end
