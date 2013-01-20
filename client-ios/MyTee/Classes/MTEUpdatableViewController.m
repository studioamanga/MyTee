//
//  MTEUpdatableViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 7/23/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEUpdatableViewController.h"

@implementation MTEUpdatableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAfterSync) name:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTE_NOTIFICATION_SYNC_FINISHED object:nil];
}

- (void)updateAfterSync
{
    
}

@end
