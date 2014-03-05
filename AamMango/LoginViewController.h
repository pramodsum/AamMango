//
//  LoginViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/15/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Utility.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *login_btn;
@property (strong, nonatomic) IBOutlet UIButton *signup_btn;
@property (strong, nonatomic) IBOutlet UIButton *facebook_btn;
@property (strong, nonatomic) IBOutlet UIButton *twitter_btn;

- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)facebookLogin:(id)sender;
- (IBAction)twitterLogin:(id)sender;

@end
