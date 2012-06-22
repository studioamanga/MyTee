//
//  MTESettingsManager.h
//  mytee
//
//  Created by Vincent Tourraine on 2/19/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

@interface MTESettingsManager : NSObject

+ (BOOL)isRemindersActive;
+ (void)setRemindersActive:(BOOL)active;

+ (NSUInteger)remindersHour;

@end
