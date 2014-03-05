//
//  ProfileViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/16/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *elephant;
@property (strong, nonatomic) IBOutlet UIImageView *profilepic;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UIButton *logout_btn;
- (IBAction)logout:(id)sender;

@end
