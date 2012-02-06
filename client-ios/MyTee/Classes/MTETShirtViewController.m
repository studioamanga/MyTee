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
#import "MTEStoreViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation MTETShirtViewController

@synthesize tshirt;
@synthesize tshirtImageView;
@synthesize storeButton;
@synthesize ratingLabel;
@synthesize sizeLabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [(UIScrollView*)self.view setAlwaysBounceVertical:YES];
    self.title = tshirt.name;
    
    [[self.sizeLabel layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.sizeLabel layer] setBorderWidth:1];
    [[self.sizeLabel layer] setCornerRadius:6];
    self.sizeLabel.text = tshirt.size;
    
    NSMutableString * ratingString = [NSMutableString stringWithString:@""];
    NSUInteger i = 0;
    NSUInteger rating = [tshirt.rating intValue];
    for( ; i<rating ; i++)
        [ratingString appendString:@"★"];
    for( ; i<5 ; i++)
        [ratingString appendString:@"☆"];
    self.ratingLabel.text = ratingString;
    
    [self.storeButton setTitle:tshirt.store.name forState:UIControlStateNormal];
    
    NSString * pathToImage = [MTETShirt pathToLocalImageWithIdentifier:tshirt.identifier];
    UIImage * image = [UIImage imageWithContentsOfFile:pathToImage];
    [self.tshirtImageView setImage:image];
    
    //[[self.tshirtImageView layer] setShadowRadius:7];
    //[[self.tshirtImageView layer] setShadowColor:[[UIColor blackColor] CGColor]];
    //[[self.tshirtImageView layer] setShadowOpacity:0.7];
    [[self.tshirtImageView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.tshirtImageView layer] setBorderWidth:1];
    
    UIImage * woodTexture = [UIImage imageNamed:@"wood"];
    UIColor * woodColor = [UIColor colorWithPatternImage:woodTexture];
    [self.view setBackgroundColor:woodColor];
    
    [(UIScrollView*)self.view setContentSize:CGSizeMake(self.view.frame.size.width, self.storeButton.frame.origin.y+150)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setRatingLabel:nil];
    [self setSizeLabel:nil];
    
    [self setTshirtImageView:nil];
    [self setStoreButton:nil];
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
    if ([[segue identifier] isEqualToString:@"MTEStoreSegue"])
    {
        MTEStoreViewController * viewController = segue.destinationViewController;
        viewController.store = tshirt.store;
    }
}

@end
