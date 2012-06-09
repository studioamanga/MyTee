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

#import "MTESyncManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation MTETShirtViewController

@synthesize tshirt = _tshirt;
@synthesize tshirtImageView;
@synthesize storeButton;
@synthesize ratingLabel;
@synthesize sizeLabel;
@synthesize tagsLabel;
@synthesize noteLabel;
@synthesize noteIconImageView;

@synthesize wearWashActionSheet;
@synthesize masterPopoverController;

#pragma mark - View lifecycle

- (void)setTshirt:(MTETShirt *)newTShirt
{
    if (_tshirt != newTShirt) {
        _tshirt = newTShirt;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    if (!self.tshirt)
    {
        for (UIView * view in self.view.subviews)
        {
            view.hidden = YES;
        }
    }
    else
    {
        for (UIView * view in self.view.subviews)
        {
            view.hidden = NO;
        }
        
        self.title = self.tshirt.name;
    
        self.sizeLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        self.sizeLabel.layer.borderWidth = 1;
        self.sizeLabel.layer.cornerRadius = 6;
        self.sizeLabel.text = self.tshirt.size;
    
        self.tagsLabel.text = self.tshirt.tags;
        
        NSMutableString * ratingString = [NSMutableString stringWithString:@""];
        NSUInteger i = 0;
        NSUInteger rating = [self.tshirt.rating intValue];
        for( ; i<rating ; i++)
            [ratingString appendString:@"★"];
        for( ; i<5 ; i++)
            [ratingString appendString:@"☆"];
        self.ratingLabel.text = ratingString;
        
        if (self.tshirt.note.length > 0)
        {
            CGSize noteSize = [self.tshirt.note sizeWithFont:self.noteLabel.font constrainedToSize:CGSizeMake(self.noteLabel.frame.size.width, 9999)];
            self.noteLabel.frame = CGRectMake(self.noteLabel.frame.origin.x, self.noteLabel.frame.origin.y, self.noteLabel.frame.size.width, noteSize.height);
            self.noteLabel.text = self.tshirt.note;
            self.noteIconImageView.hidden = NO;
        }
        else
        {
            self.noteLabel.text = @"";
            self.noteIconImageView.hidden = YES;
        }
        
        [self.storeButton setTitle:self.tshirt.store.name forState:UIControlStateNormal];
        
        NSString * pathToImage = [MTETShirt pathToLocalImageWithIdentifier:self.tshirt.identifier];
        UIImage * image = [UIImage imageWithContentsOfFile:pathToImage];
        self.tshirtImageView.image = image;
        
        self.tshirtImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.tshirtImageView.layer.borderWidth = 1;
        
        ((UIScrollView*)self.view).contentSize = CGSizeMake(self.view.frame.size.width, self.noteLabel.frame.origin.y+self.noteLabel.frame.size.height+50);
    }
    
    UIImage * woodTexture = [UIImage imageNamed:@"wood"];
    UIColor * woodColor = [UIColor colorWithPatternImage:woodTexture];
    self.view.backgroundColor = woodColor;
}

- (IBAction)didPressAction:(id)sender
{
    self.wearWashActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Wear today", @"Wash today", nil];
    
    [self.wearWashActionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:
                             [MTESyncManager emailFromKeychain], @"login",
                             [MTESyncManager passwordFromKeychain], @"password", nil];
    NSString * resourcePath = nil;
    
    switch (buttonIndex)
    {
        case 0:
            // Wear
            resourcePath = [NSString stringWithFormat:MTE_URL_API_TSHIRT_WEAR, self.tshirt.identifier];
            [[RKClient sharedClient] post:resourcePath params:params delegate:self];
            
            break;
        case 1:
            // Wash
            resourcePath = [NSString stringWithFormat:MTE_URL_API_TSHIRT_WASH, self.tshirt.identifier];
            [[RKClient sharedClient] post:resourcePath params:params delegate:self];
            
            break;
    }
    
    self.wearWashActionSheet = nil;
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTE_NOTIFICATION_SHOULD_SYNC_NOW object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [(UIScrollView*)self.view setAlwaysBounceVertical:YES];
    
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.ratingLabel = nil;
    self.sizeLabel = nil;
    self.tagsLabel = nil;
    self.noteLabel = nil;
    self.tshirtImageView = nil;
    self.storeButton = nil;
    self.noteIconImageView = nil;
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
        viewController.datesObjects = [self.tshirt.wears sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    }
    if ([[segue identifier] isEqualToString:@"MTEWashSegue"])
    {
        MTEWearWashViewController * viewController = segue.destinationViewController;
        viewController.datesObjects = [self.tshirt.washs sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
    }
    if ([[segue identifier] isEqualToString:@"MTEStoreSegue"])
    {
        MTEStoreViewController * viewController = segue.destinationViewController;
        viewController.store = self.tshirt.store;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"T-Shirts", @"T-Shirts");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
