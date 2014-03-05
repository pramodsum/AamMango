//
//  Card.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *english;
@property (strong, nonatomic) NSString *hindi;
@property (strong, nonatomic) NSString *translit;
//@property (strong, nonatomic) TYPE *pronounciation;
@property (strong, nonatomic) NSNumber *answered_correctly; //set like [NSNumber numberWithBool:YES]

@end
