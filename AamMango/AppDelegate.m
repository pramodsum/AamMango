//
//  AppDelegate.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "AppDelegate.h"
#import "PAPCache.h"
#import <Parse/Parse.h>
#import <OpenEars/OpenEarsLogging.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate {
    UIAlertView *OEalert;
}

@synthesize deckManager = _deckManager;

@synthesize pocketsphinxController;
@synthesize fliteController;
@synthesize usingStartLanguageModel;
@synthesize slt;
@synthesize restartAttemptsDueToPermissionRequests;
@synthesize startupFailedDueToLackOfPermissions;
@synthesize heardText;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    _deckManager = [[DeckManager alloc] init];

    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];

    [Parse setApplicationId:@"BXmWMUzGNVjulGOhKBCKhMQZwNrhOaMGhcLBMvE3"
                  clientKey:@"XLcHBiK4G3t3TWN8SbYNVklyWDaQvxFk3jvCl36B"];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [PFImageView class];

    [PFFacebookUtils initializeFacebook];
    
    //Load Openears in background
    [OpenEarsLogging startOpenEarsLogging];
    [self.openEarsEventsObserver setDelegate:self];
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:[[NSBundle mainBundle] pathForResource:@"aammango" ofType:@"arpa"] dictionaryAtPath:[[NSBundle mainBundle] pathForResource:@"aammango" ofType:@"dic"] acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelHindi"] languageModelIsJSGF:NO];
    [self.pocketsphinxController suspendRecognition];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

//    if([
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                // Microphone enabled code
                NSLog(@"Microphone enabled");
            }
            else {
                // Microphone disabled code
                NSLog(@"Microphone disabled");
                [[[UIAlertView alloc] initWithTitle:@"Microphone Error" message:@"Microphone is not enabled for this application on your device." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                
            }
        }];
//    }

    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

    //Add activityindicator to show next view is loading
    _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 20, 30)];
    [_spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    _spinner.color = [UIColor blueColor];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}



- (void)facebookRequestDidLoad:(id)result {
    // This method is called twice - once for the user's /me profile, and a second time when obtaining their friends. We will try and handle both scenarios in a single method.
    PFUser *user = [PFUser currentUser];

    NSArray *data = [result objectForKey:@"data"];

    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            if (friendData[@"id"]) {
                [facebookIds addObject:friendData[@"id"]];
            }
        }

        // cache friend data
        [[PAPCache sharedCache] setFacebookFriends:facebookIds];

        if (!user) {
            NSLog(@"No user session found. Forcing logOut.");
            [PFUser logOut];
        }
    } else {
        if (user) {
            NSString *facebookName = result[@"name"];
            if (facebookName && [facebookName length] != 0) {
                [user setObject:facebookName forKey:@"displayName"];
            } else {
                [user setObject:@"Someone" forKey:@"displayName"];
            }

            NSString *facebookId = result[@"id"];
            if (facebookId && [facebookId length] != 0) {
                [user setObject:facebookId forKey:@"facebookId"];
            }

            [user saveEventually];
        }

        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
}

- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);

    if ([PFUser currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            [PFUser logOut];
        }
    }
}



- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
    NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID); // Log it.
    NSLog(@"----------------------------------------");
    
    self.heardText = [NSString stringWithFormat:@"Heard: \"%@\"", hypothesis]; // Show it in the status box.
    
    NSString *message = [NSString stringWithFormat:@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID];
    NSLog(@"%@", message);
    
//    [self checkPronunciationCorrectness:hypothesis recognitionScore:recognitionScore utteranceID:utteranceID];
}

//- (void)checkPronunciationCorrectness:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
//    if([hypothesis isEqual:card.english]) {
//        NSString *message = [NSString stringWithFormat:@"You said %@ correctly!", card.hindi];
//        OEalert = [[UIAlertView alloc] initWithTitle: @"Correct!"
//                                           message: message
//                                          delegate: nil
//                                 cancelButtonTitle:@"OK"
//                                 otherButtonTitles:nil];
//        [OEalert show];
//    } else {
//        NSString *message = [NSString stringWithFormat:@"Sounds like you said %@ instead. Try again!", hypothesis];
//        OEalert = [[UIAlertView alloc] initWithTitle: @"Wrong!"
//                                           message: message
//                                          delegate: nil
//                                 cancelButtonTitle:@"OK"
//                                 otherButtonTitles:nil];
//        [OEalert show];
//    }
//}

// OpenEars
- (OpenEarsEventsObserver *)openEarsEventsObserver {
    if (openEarsEventsObserver == nil) {
        openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
    }
    return openEarsEventsObserver;
}

// Lazily allocated PocketsphinxController.
- (PocketsphinxController *)pocketsphinxController {
    if (pocketsphinxController == nil) {
        pocketsphinxController = [[PocketsphinxController alloc] init];
        pocketsphinxController.verbosePocketSphinx = TRUE; // Uncomment me for verbose debug output
        pocketsphinxController.outputAudio = TRUE;
#ifdef kGetNbest
        pocketsphinxController.returnNbest = TRUE;
        pocketsphinxController.nBestNumber = 5;
#endif
    }
    return pocketsphinxController;
}

// Lazily allocated slt voice.
- (Slt *)slt {
    if (slt == nil) {
        slt = [[Slt alloc] init];
    }
    return slt;
}

// Lazily allocated FliteController.
- (FliteController *)fliteController {
    if (fliteController == nil) {
        fliteController = [[FliteController alloc] init];
        
    }
    return fliteController;
}

#pragma mark OpenEars Delegate Functions

- (void) pocketsphinxDidStartCalibration {
    NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
    NSLog(@"Pocketsphinx calibration is complete.");
    [self.pocketsphinxController suspendRecognition];
}

- (void) pocketsphinxDidStartListening {
    NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
    [OEalert dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"Pocketsphinx has detected speech.");
    OEalert = [[UIAlertView alloc] initWithTitle:@"Speech Detected" message:@""
                                      delegate:self
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [OEalert show];
    
}

- (void) suspendDetection {
    [self.pocketsphinxController suspendRecognition];
}

- (void) pocketsphinxDidDetectFinishedSpeech {
    NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
    [OEalert dismissWithClickedButtonIndex:0 animated:YES];
    [self performSelector:@selector(suspendDetection) withObject:nil afterDelay:1];
}

- (void) pocketsphinxDidStopListening {
    NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
    NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
    NSLog(@"Pocketsphinx has resumed recognition.");
    [OEalert dismissWithClickedButtonIndex:0 animated:YES];
    OEalert = [[UIAlertView alloc] initWithTitle:@"Speak" message:@""
                                        delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:nil];
    [OEalert show];
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
    NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
    [OEalert dismissWithClickedButtonIndex:0 animated:YES];
    OEalert = [[UIAlertView alloc] initWithTitle:@"Setup Failed"
                                       message:@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more."
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    [OEalert show];
}

- (void) testRecognitionCompleted {
    NSLog(@"A test file that was submitted for recognition is now complete.");
}

@end
