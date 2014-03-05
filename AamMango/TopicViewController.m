//
//  TopicViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "TopicViewController.h"
#import "NumberCards.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

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

    if([self.navigationItem.title  isEqual: @"Numbers"]) {
        NumberCards *numberCardController = [[NumberCards alloc] init];
        [numberCardController initNumberCards];
        _cards = [[NSArray alloc] initWithArray: numberCardController.numberCards];
    }
    else if([self.navigationItem.title  isEqual: @"Fruits"]) {
        _cards = _fruitCards;
    }
    else if([self.navigationItem.title  isEqual: @"Vegetables"]) {
        _cards = _vegetableCards;
    }
    else if([self.navigationItem.title  isEqual: @"Emotions"]) {
        _cards = _emotionCards;
    }

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
    if (index == [self.cards count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (TopicContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.cards count] == 0) || (index >= [self.cards count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    TopicContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopicContentViewController"];
    Card *c = self.cards[index];
//    pageContentViewController.titleText = c.label;
//    pageContentViewController.cardLabel.text = c.label;
//    pageContentViewController.subtitleText = c.english;
//    pageContentViewController.cardEnglishLabel.text = c.english;
//    pageContentViewController.imageFile = c.image;
//    pageContentViewController.cardImage.image = [UIImage imageNamed:c.image];
    pageContentViewController.pageIndex = index;
    pageContentViewController.card = self.cards[index];

    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.cards count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
