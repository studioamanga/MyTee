//
//  MTESettingsManager.m
//  mytee
//
//  Created by Vincent Tourraine on 2/19/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTESettingsManager.h"

#define MTE_USER_DEFAULTS_REMINDERS_ACTIVE @"kMTEUserDefaultsRemindersActive"

@implementation MTESettingsManager

+ (BOOL)isRemindersActive
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:MTE_USER_DEFAULTS_REMINDERS_ACTIVE];
}

+ (void)setRemindersActive:(BOOL)active
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:active forKey:MTE_USER_DEFAULTS_REMINDERS_ACTIVE];
    [userDefaults synchronize];
}

@end
