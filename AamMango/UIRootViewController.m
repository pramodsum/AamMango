//
//  UIRootViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 10/31/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "UIRootViewController.h"
#import "AppDelegate.h"
#import "TopicViewController.h"
#import <Parse/Parse.h>

@implementation UIRootViewController {
    NSArray *topics;
    AppDelegate *appDelegate;
    NSString *selectedTopic;
}

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    topics = [NSArray arrayWithObjects: @"Number", @"Appetizer", @"Beverages", @"Breads", @"Curry", @"Dessert", @"Proteins", @"Rice Dish", @"Sides", @"South Indian Specialties", @"Vegetables", @"Vegetarian Dishes", @"None", nil];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view addSubview:appDelegate.spinner];
    
    [appDelegate.pocketsphinxController suspendRecognition];
    
    [self InitImgBtns];
    
    //Init alertview
    //    UIAlertView *name_dialog = [[UIAlertView alloc]
    //                                initWithTitle:@"What should I call you?" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [name_dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    //    [name_dialog show];
}

- (void) InitImgBtns {
    [_Number addTarget:self
                action:@selector(showTopicCards:)
      forControlEvents:UIControlEventTouchUpInside];
    [_Appetizer addTarget:self
                action:@selector(showTopicCards:)
      forControlEvents:UIControlEventTouchUpInside];
    [_Beverages addTarget:self
                action:@selector(showTopicCards:)
      forControlEvents:UIControlEventTouchUpInside];
    [_Breads addTarget:self
                action:@selector(showTopicCards:)
      forControlEvents:UIControlEventTouchUpInside];
    [_Curry addTarget:self
                action:@selector(showTopicCards:)
      forControlEvents:UIControlEventTouchUpInside];
    [_Dessert addTarget:self
                action:@selector(showTopicCards:)
       forControlEvents:UIControlEventTouchUpInside];
    [_Proteins addTarget:self
                 action:@selector(showTopicCards:)
       forControlEvents:UIControlEventTouchUpInside];
    [_Rice_Dishes addTarget:self
                 action:@selector(showTopicCards:)
       forControlEvents:UIControlEventTouchUpInside];
    [_Sides addTarget:self
                 action:@selector(showTopicCards:)
       forControlEvents:UIControlEventTouchUpInside];
    [_South_Indian_Specialties addTarget:self
                 action:@selector(showTopicCards:)
       forControlEvents:UIControlEventTouchUpInside];
    [_Vegetables addTarget:self
                 action:@selector(showTopicCards:)
          forControlEvents:UIControlEventTouchUpInside];
    [_Vegetarian_Dishes addTarget:self
                    action:@selector(showTopicCards:)
          forControlEvents:UIControlEventTouchUpInside];
    [_None addTarget:self
              action:@selector(showTopicCards:)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void) showTopicCards: (id) sender{
    UIButton *clicked = (UIButton *) sender;
    selectedTopic = [clicked.restorationIdentifier stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    NSLog(@"%@",selectedTopic);
    [self performSegueWithIdentifier:@"showTopicCards" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTopicCards"]) {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        
        TopicViewController *foo = [segue destinationViewController];
        foo.navigationItem.title = selectedTopic;
        
        //Load deck
        [foo setAppDelegate:appDelegate];
        [foo.appDelegate.deckManager changeDeck: selectedTopic];
        NSLog(@"SIZE: %lu", (unsigned long)foo.appDelegate.deckManager.count);
        
        // Wait for deck to load
        while(!foo.appDelegate.deckManager.isDeckLoaded) {
            //            NSLog(@"SIZE: %lu", (unsigned long)foo.appDelegate.deckManager.count);
            [appDelegate.spinner startAnimating];
        }
        [appDelegate.spinner stopAnimating];
    } else if ([segue.identifier isEqualToString:@"rootlogout_segue"]) {
        [PFUser logOut];
    }
}

-(void)threadStartAnimating:(id)data
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *name = [[alertView textFieldAtIndex:0]text];
    if([name length] >= 10) {
        return YES;
    }
    return NO;
}

- (IBAction)viewProfile:(id)sender {
    //    [spinner stopAnimating];
    [self performSegueWithIdentifier:@"profileview_segue" sender:self];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    //    [spinner stopAnimating];
    [self performSegueWithIdentifier:@"rootlogout_segue" sender:self];
}

@end
