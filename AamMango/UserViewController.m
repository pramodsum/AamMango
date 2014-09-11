//
//  UserViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/15/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface UserViewController ()

@end

@implementation UserViewController

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

    [_logout_btn setHidden:YES];
    [_status setHidden:YES];
    [_begin_btn setHidden:YES];
    [_login_btn setHidden:YES];
    [_signup_btn setHidden:YES];

//    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        [self performSegueWithIdentifier:@"beginSegue" sender:self];
//    }

//    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:
        [UIColor colorWithRed:102/255.0f green:102/255.0f blue:255/255.0f alpha:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkStatus];
}

- (void)checkStatus {
    NSLog(@"Splash - checkStatus");
    [_logout_btn setHidden:YES];
    [_status setHidden:YES];
    [_begin_btn setHidden:YES];
    [_login_btn setHidden:YES];
    [_signup_btn setHidden:YES];

    if ([PFUser currentUser]) {
        [_logout_btn setHidden:NO];
        [_begin_btn setHidden:NO];
        [_status setHidden:NO];

        FBRequest *request = [FBRequest requestForMe];

        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;

                NSString *name = userData[@"name"];
                
                // Now add the data to the UI elements
                self.status.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), name];
            }
        }];
    } else {
        [_login_btn setHidden:NO];
        [_signup_btn setHidden:NO];
    }
}

- (IBAction)login_segue:(id)sender {
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

- (IBAction)signup_segue:(id)sender {
    [self performSegueWithIdentifier:@"SignupSegue" sender:self];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self checkStatus];
}

- (IBAction)begin:(id)sender {
    [self performSegueWithIdentifier:@"beginSegue" sender:self];
}

@end
