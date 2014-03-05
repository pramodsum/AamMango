//
//  ViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *profile_btn;
- (IBAction)viewProfile:(id)sender;
- (IBAction)logout:(id)sender;

@end
