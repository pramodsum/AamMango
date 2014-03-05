//
//  Utility.h
//  AamMango
//
//  Created by Sumedha Pramod on 2/17/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "UIImage+ResizeAdditions.h"

@interface Utility : NSObject

+ (void)processFacebookProfilePictureData:(NSData *)data;

+ (BOOL)userHasValidFacebookData:(PFUser *)user;
+ (BOOL)userHasProfilePictures:(PFUser *)user;

@end
