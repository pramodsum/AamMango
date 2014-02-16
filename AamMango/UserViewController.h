//
//  UserViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/15/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserViewController : UIViewController@property (strong, nonatomic) IBOutlet UIButton *login_btn;
@property (strong, nonatomic) IBOutlet UIButton *signup_btn;
@property (strong, nonatomic) IBOutlet UIButton *logout_btn;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIButton *begin_btn;
- (IBAction)login_segue:(id)sender;
- (IBAction)signup_segue:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)begin:(id)sender;

@end