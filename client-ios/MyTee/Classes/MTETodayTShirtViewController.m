//
//  MTETodayTShirtViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 5/2/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTETodayTShirtViewController.h"

#import "MTETShirt.h"

@interface MTETodayTShirtViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emptyDataLabel;

- (void)configureView;

@end

@implementation MTETodayTShirtViewController
@synthesize emptyDataLabel;

@synthesize managedObjectContext;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSDate * today = [NSDate date];
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    components = [gregorian components:unitFlags fromDate:today];
    components.hour = 0;
    components.minute = 0;
    NSDate * todayMidnight = [gregorian dateFromComponents:components];
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([MTETShirt class])];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"ANY wears.date > %@", todayMidnight];
    [fetchRequest setPredicate:predicate];
    
    NSError * error = nil;
    NSArray * todayTShirts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!error && todayTShirts && [todayTShirts count]>0) 
    {
        self.tshirt = [todayTShirts lastObject];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    else
    {
        self.tshirt = nil;
    }
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
    self.emptyDataLabel = nil;
}

- (void)configureView
{
    [super configureView];
    
    self.emptyDataLabel.hidden = (self.tshirt != nil);
}

@end
