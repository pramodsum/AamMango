//
//  OfflineRecognition.h
//  AamMango
//
//  Created by Sumedha Pramod on 3/16/14.
//  Copyright (c) 2014 Sumedha Pramod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/AcousticModel.h>

@interface OfflineRecognition : NSObject {
    PocketsphinxController *pocketsphinxController;
}

@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;

@end
