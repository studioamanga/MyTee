//
//  MTETShirtsFilterViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 9/8/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTETShirtsFilterViewController.h"

#import "ECSlidingViewController.h"
#import "MTETShirtExplorer.h"

@interface MTETShirtsFilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) MTETShirtsFilterType filterType;
@property (assign, nonatomic) NSUInteger filterWashParameter;

@end

@implementation MTETShirtsFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 1)]];
        self.navigationItem.rightBarButtonItem = spaceBarButtonItem;
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"linen-darker-bar"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"linen-darker-bar-landscape"] forBarMetrics:UIBarMetricsLandscapePhone];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.filterType = [userDefaults integerForKey:kMTETShirtsFilterType];
    self.filterWashParameter = [userDefaults integerForKey:kMTETShirtsFilterParameter];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:self.filterType inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ? 110 : 380, 1)]];
        self.navigationItem.rightBarButtonItem = spaceBarButtonItem;
    }
}

#pragma mark - Table data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MTEFilterCell"];
    
    switch (indexPath.row)
    {
        case MTETShirtsFilterAll:
            cell.textLabel.text = @"All My T-Shirts";
            cell.imageView.image = [UIImage imageNamed:@"33-cabinet-w"];
            cell.imageView.highlightedImage = [UIImage imageNamed:@"33-cabinet-b"];
            break;
        case MTETShirtsFilterWear:
            cell.textLabel.text = @"Wear";
            cell.imageView.image = [UIImage imageNamed:@"67-tshirt-w"];
            cell.imageView.highlightedImage = [UIImage imageNamed:@"67-tshirt-b"];
            break;
        case MTETShirtsFilterWash:
            cell.textLabel.text = @"Wash";
            cell.imageView.image = [UIImage imageNamed:@"wash-w"];
            cell.imageView.highlightedImage = [UIImage imageNamed:@"wash-b"];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.filterType = indexPath.row;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.filterType forKey:kMTETShirtsFilterType];
    [userDefaults synchronize];
    
    [self.delegate tshirtsFilterViewControllerDidChangeFilter:self];
    
    [self.slidingViewController resetTopView];
}

@end
