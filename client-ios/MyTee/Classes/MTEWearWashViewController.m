//
//  MTEWearWashViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEWearWashViewController.h"

@implementation MTEWearWashViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage * woodTexture = [UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"shelves-free-form" : @"shelves-free"];
    UIColor * woodColor = [UIColor colorWithPatternImage:woodTexture];
    self.view.backgroundColor = woodColor;
    
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateStyle = NSDateFormatterFullStyle;
    self.dateFormatter.doesRelativeDateFormatting = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datesObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTEDateCell"];
    
    id object = [self.datesObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = [[self.dateFormatter stringFromDate:[object date]] capitalizedString];
    
    return cell;
}

@end
