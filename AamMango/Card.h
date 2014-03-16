//
//  Card.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>

@interface Card : NSObject

@property (retain) NSString *english;
@property (retain) NSString *hindi;
@property (retain) NSString *translit;
@property (retain) NSString *category;

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@property (strong, nonatomic) NSNumber *answeredCorrectly; //set like [NSNumber numberWithBool:YES]

//Methods
-(void) pronounce;
-(void) pronounceString:(NSString *) str;
-(void) announceError;
-(BOOL) isAnsweredCorrectly;

@end
