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
#import "MTEAuthenticationManager.h"
#import "MTEMyTeeAPIClient.h"

#import <AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

@interface MTETShirtViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
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
        for (UIView *view in self.view.subviews)
            view.hidden = YES;
    }
    else
    {
        for (UIView *view in self.view.subviews)
            view.hidden = NO;
        
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
        
        MTEWear *mostRecentWear = [self.tshirt mostRecentWear];
        if (mostRecentWear)
            [self.wearButton setTitle:[NSString stringWithFormat:@"Last worn %@", [self relativeDescriptionForDate:mostRecentWear.date]]
                             forState:UIControlStateNormal];
        else
            [self.wearButton setTitle:@"Never worn before" forState:UIControlStateNormal];
        
        MTEWash *mostRecentWash = [self.tshirt mostRecentWash];
        if (mostRecentWash)
            [self.washButton setTitle:[NSString stringWithFormat:@"Last washed %@", [self relativeDescriptionForDate:mostRecentWash.date]]
                             forState:UIControlStateNormal];
        else
            [self.washButton setTitle:@"Never washed before" forState:UIControlStateNormal];
        
        [self.tshirtImageView setImageWithURL:[NSURL URLWithString:self.tshirt.image_url]];
        
        self.tshirtImageView.layer.borderColor = [[UIColor blackColor] CGColor];
        self.tshirtImageView.layer.borderWidth = 1;
        self.tshirtImageView.layer.cornerRadius = 6;
        self.tshirtImageView.clipsToBounds = YES;
        
        self.mainScrollView.contentSize = CGSizeMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 540 : self.view.frame.size.width, self.noteLabel.frame.origin.y+self.noteLabel.frame.size.height+50);
    }
    
    UIImage *woodTexture = [UIImage imageNamed:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"shelves-free-form" : @"shelves-closeup"];
    UIColor *woodColor = [UIColor colorWithPatternImage:woodTexture];
    self.mainScrollView.backgroundColor = woodColor;
}

- (NSString*)relativeDescriptionForDate:(NSDate*)date
{
    NSInteger nbDaysAgo = (int)[date timeIntervalSinceNow]/(-60*60*24);
    
    if (nbDaysAgo == 0)
        return @"today";
    else if (nbDaysAgo == 1)
        return @"yesterday";
    
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
    if (self.wearWashActionSheet)
        return;
    
    self.wearWashActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Wear today", @"Wash today", nil];
    
    [self.wearWashActionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            // Wear
            MTEWear *wear = [[MTEWear alloc] initInManagedObjectContext:self.tshirt.managedObjectContext];
            [self.tshirt.managedObjectContext insertObject:wear];
            wear.date   = [NSDate date];
            wear.tshirt = self.tshirt;
            break;
        }
        case 1:
        {
            // Wash
            MTEWash *wash = [[MTEWash alloc] initInManagedObjectContext:self.tshirt.managedObjectContext];
            [self.tshirt.managedObjectContext insertObject:wash];
            wash.date   = [NSDate date];
            wash.tshirt = self.tshirt;
            break;
        }
    }
    
    NSError *error = nil;
    if (![self.tshirt.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
    }
    
    [self configureView];
    self.wearWashActionSheet = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.doesRelativeDateFormatting = YES;
    
    [self configureView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MTEWearSegue"])
    {
        MTEWearWashViewController *viewController = segue.destinationViewController;
        viewController.datesObjects = [self.tshirt wearsSortedByDate];
    }
    else if ([segue.identifier isEqualToString:@"MTEWashSegue"])
    {
        MTEWearWashViewController *viewController = segue.destinationViewController;
        viewController.datesObjects = [self.tshirt washsSortedByDate];
    }
    else if ([segue.identifier isEqualToString:@"MTEStoreSegue"] ||
             [segue.identifier isEqualToString:@"MTEStoreRetailSegue"] ||
             [segue.identifier isEqualToString:@"MTEStoreOnlineSegue"])
    {
        MTEStoreViewController *viewController = segue.destinationViewController;
        viewController.store = self.tshirt.store;
    }
}

- (IBAction)dismissViewController:(id)sender
{
    if (self.wearWashActionSheet)
        [self.wearWashActionSheet dismissWithClickedButtonIndex:self.wearWashActionSheet.cancelButtonIndex animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
