//
//  MTESettingsManager.h
//  mytee
//
//  Created by Vincent Tourraine on 2/19/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTESettingsManager : NSObject

+ (BOOL)isRemindersActive;
+ (void)setRemindersActive:(BOOL)active;

@end
