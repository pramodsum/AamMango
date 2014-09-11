//
//  TopicViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "AppDelegate.h"
#import "TopicViewController.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

@synthesize appDelegate;

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

    [self.navigationController.navigationBar setHidden:NO];

    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicViewController"];
    self.pageViewController.dataSource = self;

    TopicContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20);

    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TopicContentViewController*) viewController).pageIndex;

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TopicContentViewController*) viewController).pageIndex;

    if (index == NSNotFound) {
        return nil;
    }

    index++;
    if (index == [appDelegate.deckManager count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (TopicContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([appDelegate.deckManager count] == 0) || (index >= [appDelegate.deckManager count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    TopicContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicContentViewController"];
    pageContentViewController.pageIndex = index;
    pageContentViewController.card = [appDelegate.deckManager getCard:index];
    pageContentViewController.deckArray = [appDelegate.deckManager getDeckArray];

    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [appDelegate.deckManager count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
