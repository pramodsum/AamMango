//
//  TopicViewController.m
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import "TopicViewController.h"

@interface TopicViewController ()

@end

@implementation TopicViewController

@synthesize cardLabel;

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
        _cards = _numberCards;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
