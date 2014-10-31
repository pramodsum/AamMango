//
//  UIRootViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 10/31/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRootViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *profile_btn;

- (IBAction)viewProfile:(id)sender;
- (IBAction)logout:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *Number;
@property (weak, nonatomic) IBOutlet UIButton *Appetizer;
@property (weak, nonatomic) IBOutlet UIButton *Beverages;
@property (weak, nonatomic) IBOutlet UIButton *Breads;
@property (weak, nonatomic) IBOutlet UIButton *Curry;
@property (weak, nonatomic) IBOutlet UIButton *Dessert;
@property (weak, nonatomic) IBOutlet UIButton *Proteins;
@property (weak, nonatomic) IBOutlet UIButton *Rice_Dishes;
@property (weak, nonatomic) IBOutlet UIButton *Sides;
@property (weak, nonatomic) IBOutlet UIButton *South_Indian_Specialties;
@property (weak, nonatomic) IBOutlet UIButton *Vegetables;
@property (weak, nonatomic) IBOutlet UIButton *Vegetarian_Dishes;
@property (weak, nonatomic) IBOutlet UIButton *None;


@end