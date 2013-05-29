//
//  MTESettingsManager.m
//  mytee
//
//  Created by Vincent Tourraine on 2/19/12.
//  Copyright (c) 2012-2013 Studio AMANgA. All rights reserved.
//

#import "MTESettingsManager.h"

#define MTE_USER_DEFAULTS_REMINDERS_ACTIVE @"kMTEUserDefaultsRemindersActive"

#define MTE_REMINDER_HOUR 8

@implementation MTESettingsManager

+ (BOOL)isRemindersActive
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:MTE_USER_DEFAULTS_REMINDERS_ACTIVE];
}

+ (NSDate*)dateForNextReminder
{
    NSUInteger reminderHour = [self remindersHour];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComponents = [calendar components:(NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                                  fromDate:[NSDate date]];
    
    NSInteger nowHour  = [nowComponents hour];
    NSInteger nowDay   = [nowComponents day];
    NSInteger nowMonth = [nowComponents month];
    NSInteger nowYear  = [nowComponents year];
    
    NSDateComponents *components = [NSDateComponents new];
    [components setHour:reminderHour];
    [components setDay:nowDay]; 
    [components setMonth:nowMonth]; 
    [components setYear:nowYear];
    NSDate *thisDate = [calendar dateFromComponents:components];
    
    if (nowHour > reminderHour)
        thisDate = [thisDate dateByAddingTimeInterval:60*60*24];
    
    return thisDate;
}

+ (void)setRemindersActive:(BOOL)active
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:active forKey:MTE_USER_DEFAULTS_REMINDERS_ACTIVE];
    [userDefaults synchronize];
    
    // Scheduling notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (active)
    {
        UILocalNotification *notification = [UILocalNotification new];
        notification.fireDate       = [self dateForNextReminder];
        notification.timeZone       = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = kCFCalendarUnitDay;
        notification.repeatCalendar = [NSCalendar currentCalendar];
        notification.alertAction    = @"choose";
        notification.alertBody      = @"Let’s choose something awesome!";
        notification.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    else
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

+ (NSUInteger)remindersHour
{
    return MTE_REMINDER_HOUR;
}

@end
