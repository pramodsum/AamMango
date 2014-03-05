//
//  ProfileViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/16/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _score.text = [NSString stringWithFormat:@"%@", [[PFUser currentUser] valueForKey:@"Score"]];
    _score.layer.cornerRadius = 12.0f;
    _email.text = [@"Email: " stringByAppendingString:[[PFUser currentUser] email]];

    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [_elephant setHidden:YES];

        // Send request to Facebook
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            // handle response
            if (!error) {
                // Parse the data received
                NSDictionary *userData = (NSDictionary *)result;

                NSString *facebookID = userData[@"id"];

                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];


                NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];

                NSString *name = userData[@"name"];

                // Now add the data to the UI elements
                _name.text = name;

                if (facebookID) {
                    userProfile[@"facebookId"] = facebookID;
                }

                if (userData[@"name"]) {
                    userProfile[@"name"] = userData[@"name"];
                }

                if ([pictureURL absoluteString]) {
                    userProfile[@"pictureURL"] = [pictureURL absoluteString];
                }

                // Download the user's facebook profile picture
                self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here

                if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
                    NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];

                    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                          timeoutInterval:2.0f];
                    // Run network request asynchronously
                    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
                    if (!urlConnection) {
                        NSLog(@"Failed to download picture");
                    }
                }

                [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
                [[PFUser currentUser] saveInBackground];
            } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                        isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
                NSLog(@"The facebook session was invalidated");
                [PFUser logOut];
                [self performSegueWithIdentifier:@"logout_segue" sender:self];
                
            } else {
                NSLog(@"Some other error: %@", error);
            }
        }];
    }
}

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    _profilepic.image = [UIImage imageWithData:_imageData];

    _profilepic.layer.cornerRadius = 64.0f;
    _profilepic.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"logout_segue" sender:self];
}
@end
