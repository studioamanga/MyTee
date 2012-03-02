//
//  MTETShirtViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTETShirt;

@interface MTETShirtViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) MTETShirt * tshirt;

@property (weak, nonatomic) IBOutlet UIImageView *tshirtImageView;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noteIconImageView;

@property (strong, nonatomic) UIPopoverController * masterPopoverController;

- (void)configureView;
- (IBAction)didPressAction:(id)sender;


@end
