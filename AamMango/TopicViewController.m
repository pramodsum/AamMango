//
//  TopicViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "TopicViewController.h"
#import "SWRevealViewController.h"

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
        [self initNumberCards];
        _cards = [[NSArray alloc] initWithArray:_numberCards];
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
    pageContentViewController.titleText = c.label;
    pageContentViewController.cardLabel.text = c.label;
    pageContentViewController.subtitleText = c.english;
    pageContentViewController.cardEnglishLabel.text = c.english;
    pageContentViewController.imageFile = c.image;
    pageContentViewController.cardImage.image = [UIImage imageNamed:c.image];
    pageContentViewController.pageIndex = index;

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

- (void) initNumberCards {
    Card *c1 = [[Card alloc] init],
        *c2 = [[Card alloc] init],
        *c3 = [[Card alloc] init],
        *c4 = [[Card alloc] init],
        *c5 = [[Card alloc] init],
        *c6 = [[Card alloc] init],
        *c7 = [[Card alloc] init],
        *c8 = [[Card alloc] init],
        *c9 = [[Card alloc] init],
        *c10 = [[Card alloc] init];
    c1.label = @"Ek";
    c1.image = @"number_one";
    c1.english = @"One";
    c2.label = @"Do";
    c2.image = @"number_two";
    c2.english = @"Two";
    c3.label = @"Theen";
    c3.image = @"number_three";
    c3.english = @"Three";
    c4.label = @"Chaar";
    c4.image = @"number_four";
    c4.english = @"Four";
    c5.label = @"Paanch";
    c5.image = @"number_five";
    c5.english = @"Five";
    c6.label = @"Che";
    c6.image = @"number_six";
    c6.english = @"Six";
    c7.label = @"Saath";
    c7.image = @"number_seven";
    c7.english = @"Seven";
    c8.label = @"Aat";
    c8.image = @"number_eight";
    c8.english = @"Eight";
    c9.label = @"Nau";
    c9.image = @"number_nine";
    c9.english = @"Nine";
    c10.label = @"Dus";
    c10.image = @"number_ten";
    c10.english = @"Ten";

    _numberCards = [[NSArray alloc]
                    initWithObjects: c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, nil];
}

@end
