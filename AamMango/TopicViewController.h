//
//  TopicViewController.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/12/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicContentViewController.h"

@interface TopicViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSArray *cards;
@property (strong, nonatomic) NSArray *fruitCards;
@property (strong, nonatomic) NSArray *vegetableCards;
@property (strong, nonatomic) NSArray *emotionCards;

@end
