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

#import <OpenEars/OpenEarsEventsObserver.h>
#import "OfflineRecognition.h"
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/AcousticModel.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, OpenEarsEventsObserverDelegate> {
    OpenEarsEventsObserver *openEarsEventsObserver;
    Slt *slt;
    
    // These three are important OpenEars classes that ViewController demonstrates the use of. There is a fourth important class (LanguageModelGenerator) demonstrated
    // inside the ViewController implementation in the method viewDidLoad.
    
    PocketsphinxController *pocketsphinxController; // The controller for Pocketsphinx (voice recognition).
    FliteController *fliteController; // The controller for Flite (speech).
    
    // Some UI, not specifically related to OpenEars.
    BOOL usingStartLanguageModel;
    int restartAttemptsDueToPermissionRequests;
    BOOL startupFailedDueToLackOfPermissions;
}

// These three are the important OpenEars objects that this class demonstrates the use of.
@property (nonatomic, strong) Slt *slt;

@property (nonatomic, strong) OpenEarsEventsObserver *openEarsEventsObserver;
@property (nonatomic, strong) PocketsphinxController *pocketsphinxController;
@property (nonatomic, strong) FliteController *fliteController;

@property (nonatomic, assign) BOOL usingStartLanguageModel;
@property (nonatomic, assign) int restartAttemptsDueToPermissionRequests;
@property (nonatomic, assign) BOOL startupFailedDueToLackOfPermissions;

@property (nonatomic, assign) NSString *heardText;

@property (strong, nonatomic) UIWindow *window;

- (void)facebookRequestDidLoad:(id)result;
- (void)facebookRequestDidFailWithError:(NSError *)error;

@property (readonly, strong, nonatomic) DeckManager *deckManager;
@property (readonly, strong, nonatomic) UIActivityIndicatorView *spinner;

@end
