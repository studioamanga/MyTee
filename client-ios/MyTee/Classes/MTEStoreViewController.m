//
//  MTEStoreViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 2/5/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTEStoreViewController.h"

#import "MTEStore.h"

@implementation MTEStoreViewController

@synthesize store;

@synthesize nameLabel;
@synthesize typeLabel;
@synthesize addressIconImageView;
@synthesize addressLabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.store.name;
    self.typeLabel.text = self.store.type;
    
    if ([self.store.type isEqualToString:@"Web"])
    {
        self.addressLabel.text = store.url;
    }
    else
    {
        self.addressLabel.text = store.address;
    }
    
    [(UIScrollView*)self.view setAlwaysBounceVertical:YES];
    
    UIImage * woodTexture = [UIImage imageNamed:@"wood"];
    UIColor * woodColor = [UIColor colorWithPatternImage:woodTexture];
    [self.view setBackgroundColor:woodColor];
}

- (void)viewDidUnload
{
    [self setTypeLabel:nil];
    [super viewDidUnload];
    
    [self setNameLabel:nil];
    [self setAddressIconImageView:nil];
    [self setAddressLabel:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
