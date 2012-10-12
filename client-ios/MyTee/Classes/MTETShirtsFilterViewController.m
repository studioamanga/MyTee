//
//  MTETShirtsFilterViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 9/8/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTETShirtsFilterViewController.h"

#import "MTETShirtsFilterCell.h"
#import "MTETShirtExplorer.h"

@interface MTETShirtsFilterViewController ()

@property (assign, nonatomic) MTETShirtsFilterType filterType;
@property (assign, nonatomic) NSUInteger filterWashParameter;
@property (strong, nonatomic) IBOutlet UIStepper *washParameterStepper;

- (IBAction)dismiss:(id)sender;
- (IBAction)washParameterStepperValueChanged:(UIStepper *)sender;

@end

@implementation MTETShirtsFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.filterType = [userDefaults integerForKey:kMTETShirtsFilterType];
    self.filterWashParameter = [userDefaults integerForKey:kMTETShirtsFilterParameter];
    
    self.tableView.backgroundView = [UIView new];
    UIImage * woodTexture = [UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"shelves-free-form" : @"shelves-free"];
    UIColor * woodColor = [UIColor colorWithPatternImage:woodTexture];
    [self.view setBackgroundColor:woodColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MTETShirtsFilterCell *cell = (MTETShirtsFilterCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:MTETShirtsFilterWash]];
    cell.label.text = [NSString stringWithFormat:@"Wash (%d)", self.filterWashParameter];
    cell.stepper.value = self.filterWashParameter;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTETShirtsFilterCell *cell = (MTETShirtsFilterCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (self.filterType == indexPath.section)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == MTETShirtsFilterWash)
        cell.label.text = [NSString stringWithFormat:@"Wash (%d)", self.filterWashParameter];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.filterType]].accessoryType = UITableViewCellAccessoryNone;
    self.filterType = indexPath.section;
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.filterType]].accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.filterType forKey:kMTETShirtsFilterType];
    [userDefaults setInteger:self.filterWashParameter forKey:kMTETShirtsFilterParameter];
    [userDefaults synchronize];
    
    [self.delegate tshirtsFilterViewControllerDidChangeFilter:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)washParameterStepperValueChanged:(UIStepper *)sender
{
    self.filterWashParameter = sender.value;
    ((MTETShirtsFilterCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:MTETShirtsFilterWash]]).label.text = [NSString stringWithFormat:@"Wash (%d)", self.filterWashParameter];
}

@end
