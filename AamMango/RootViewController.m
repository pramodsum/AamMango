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
    UIActivityIndicatorView *spinner;
}

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    topics = [NSArray arrayWithObjects:@"Numbers", nil];

    //Add activityindicator to show next view is loading
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 225, 20, 30)];
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    spinner.color = [UIColor blueColor];
    [self.view addSubview:spinner];

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
        foo.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        [foo.appDelegate.deckManager changeDeck: title];
        NSLog(@"SIZE: %li", foo.appDelegate.deckManager.count);
    }
}

-(void)threadStartAnimating:(id)data
{
    [spinner startAnimating];
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
    [spinner stopAnimating];
    [self performSegueWithIdentifier:@"profileview_segue" sender:self];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [spinner stopAnimating];
    [self performSegueWithIdentifier:@"rootlogout_segue" sender:self];
}

@end
