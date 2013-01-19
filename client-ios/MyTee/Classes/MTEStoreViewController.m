//
//  MTEStoreViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 2/5/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEStoreViewController.h"

#import "MTEStore.h"

@interface MTEStoreViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (IBAction)presentActionSheet:(id)sender;

@end

@implementation MTEStoreViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.store.name;
    self.typeLabel.text = self.store.type;
    
    if ([self.store.type isEqualToString:@"Web"])
    {
        self.addressLabel.text = self.store.url;
    }
    else
    {
        self.addressLabel.text = self.store.address;
    }
    
    ((UIScrollView*)self.view).alwaysBounceVertical = YES;
    
    UIImage * woodTexture = [UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"shelves-free-form" : @"shelves-free"];
    UIColor * woodColor = [UIColor colorWithPatternImage:woodTexture];
    [self.view setBackgroundColor:woodColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Actions

- (IBAction)presentActionSheet:(id)sender
{
    
}

@end
