//
//  MTETShirtViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTETShirtViewController.h"

#import "MTETShirt.h"
#import "MTEStore.h"
#import "MTEWash.h"
#import "MTEWear.h"

#import "MTEWearWashViewController.h"
#import "MTEStoreViewController.h"

#import "MTESyncManager.h"
#import <QuartzCore/QuartzCore.h>


@interface MTETShirtViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *tshirtImageView;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIButton *wearButton;
@property (weak, nonatomic) IBOutlet UIButton *washButton;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noteIconImageView;
@property (strong, nonatomic) NSDateFormatter * dateFormatter;
@property (strong, nonatomic) UIActionSheet * wearWashActionSheet;
@property (strong, nonatomic) UIPopoverController * masterPopoverController;

- (IBAction)didPressAction:(id)sender;
- (NSString*)relativeDescriptionForDate:(NSDate*)date;
- (IBAction)presentStoreController:(id)sender;

@end


@implementation MTETShirtViewController

@synthesize tshirt = _tshirt;
@synthesize tshirtImageView;
@synthesize storeButton;
@synthesize wearButton;
@synthesize washButton;
@synthesize ratingLabel;
@synthesize sizeLabel;
@synthesize tagsLabel;
@synthesize noteLabel;
@synthesize noteIconImageView;
@synthesize dateFormatter;

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
        self.storeButton.enabled = ![self.tshirt.store.identifier isEqualToString:MTEUnknownStoreIdentifier];
        
        MTEWear * mostRecentWear = [self.tshirt mostRecentWear];
        if (mostRecentWear)
            [self.wearButton setTitle:[NSString stringWithFormat:@"Last worn %@", [self relativeDescriptionForDate:mostRecentWear.date]]
                             forState:UIControlStateNormal];
        else
            [self.wearButton setTitle:@"Never worn before" forState:UIControlStateNormal];
        
        MTEWash * mostRecentWash = [self.tshirt mostRecentWash];
        if (mostRecentWash)
            [self.washButton setTitle:[NSString stringWithFormat:@"Last washed %@", [self relativeDescriptionForDate:mostRecentWash.date]]
                             forState:UIControlStateNormal];
        else
            [self.washButton setTitle:@"Never washed before" forState:UIControlStateNormal];
        
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

- (NSString*)relativeDescriptionForDate:(NSDate*)date
{
    NSInteger nbDaysAgo = (int)[date timeIntervalSinceNow]/(-60*60*24);
    
    if (nbDaysAgo == 0)
        return @"today";
    else if (nbDaysAgo == 1)
        return @"tomorrow";
    
    return [NSString stringWithFormat:@"%d days ago", nbDaysAgo];
}

- (IBAction)presentStoreController:(id)sender 
{
    if ([self.tshirt.store.type isEqualToString:@"Retail"])
    {
        [self performSegueWithIdentifier:@"MTEStoreRetailSegue" sender:nil];
    }
    else if ([self.tshirt.store.type isEqualToString:@"Web"])
    {
        [self performSegueWithIdentifier:@"MTEStoreOnlineSegue" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"MTEStoreSegue" sender:nil];
    }
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
    
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.doesRelativeDateFormatting = YES;
    
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
    self.wearButton = nil;
    self.washButton = nil;
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
        viewController.datesObjects = [self.tshirt wearsSortedByDate];
    }
    else if ([[segue identifier] isEqualToString:@"MTEWashSegue"])
    {
        MTEWearWashViewController * viewController = segue.destinationViewController;
        viewController.datesObjects = [self.tshirt washsSortedByDate];
    }
    else if ([[segue identifier] isEqualToString:@"MTEStoreSegue"] || 
             [[segue identifier] isEqualToString:@"MTEStoreRetailSegue"] || 
             [[segue identifier] isEqualToString:@"MTEStoreOnlineSegue"])
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
