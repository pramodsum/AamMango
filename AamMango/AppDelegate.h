//
//  AppDelegate.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DeckManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)facebookRequestDidLoad:(id)result;
- (void)facebookRequestDidFailWithError:(NSError *)error;

@property (readonly, strong, nonatomic) DeckManager *deckManager;
@property (readonly, strong, nonatomic) UIActivityIndicatorView *spinner;

@end
