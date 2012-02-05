//
//  MTETShirtViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTETShirtViewController.h"

#import "MTETShirt.h"
#import "MTEStore.h"

#import "MTEWearWashViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation MTETShirtViewController

@synthesize tshirt;
@synthesize tshirtImageView;
@synthesize storeNameLabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [(UIScrollView*)self.view setAlwaysBounceVertical:YES];
    self.title = tshirt.name;
    
    self.storeNameLabel.text = tshirt.store.name;
    
    NSString * pathToImage = [MTETShirt pathToLocalImageWithIdentifier:tshirt.identifier];
    UIImage * image = [UIImage imageWithContentsOfFile:pathToImage];
    [self.tshirtImageView setImage:image];
    
    [[self.tshirtImageView layer] setShadowRadius:7];
    [[self.tshirtImageView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[self.tshirtImageView layer] setShadowOpacity:0.7];
    [[self.tshirtImageView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.tshirtImageView layer] setBorderWidth:1];
    
    UIImage * woodTexture = [UIImage imageNamed:@"wood"];
    UIColor * woodColor = [UIColor colorWithPatternImage:woodTexture];
    [self.view setBackgroundColor:woodColor];
}

- (void)viewDidUnload
{
    [self setTshirtImageView:nil];
    [self setStoreNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"MTEWearSegue"])
    {
        MTEWearWashViewController * viewController = segue.destinationViewController;
        viewController.datesObjects = [tshirt.wears sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    }
    if ([[segue identifier] isEqualToString:@"MTEWashSegue"])
    {
        MTEWearWashViewController * viewController = segue.destinationViewController;
        viewController.datesObjects = [tshirt.washs sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    }
}

@end
