//
//  ViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "TopicViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController {
    NSArray *topics;
    AppDelegate *appDelegate;
}

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    topics = [NSArray arrayWithObjects: @"Number", @"Appetizer", @"Beverages", @"Breads", @"Curry", @"Dessert", @"Proteins", @"Rice Dish", @"Sides", @"South Indian Specialties", @"Vegetables", @"Vegetarian Dishes", @"None", nil];

    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view addSubview:appDelegate.spinner];

    //Init alertview
//    UIAlertView *name_dialog = [[UIAlertView alloc]
//                                initWithTitle:@"What should I call you?" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [name_dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    [name_dialog show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TopicCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.text = [topics objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTopicCards"]) {
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSString *title= [topics objectAtIndex:indexPath.row];

        TopicViewController *foo = [segue destinationViewController];
        foo.navigationItem.title = title;

        //Load deck
        [foo setAppDelegate:appDelegate];
        [foo.appDelegate.deckManager changeDeck: title];
        NSLog(@"SIZE: %lu", (unsigned long)foo.appDelegate.deckManager.count);

        // Wait for deck to load
        while(!foo.appDelegate.deckManager.isDeckLoaded) {
//            NSLog(@"SIZE: %lu", (unsigned long)foo.appDelegate.deckManager.count);
            [appDelegate.spinner startAnimating];
        }
        [appDelegate.spinner stopAnimating];
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
