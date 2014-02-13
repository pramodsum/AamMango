//
//  LoginViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/13/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *status;
- (IBAction)login:(id)sender;

-(IBAction)textFieldReturn:(id)sender;

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *userDB;

@end
