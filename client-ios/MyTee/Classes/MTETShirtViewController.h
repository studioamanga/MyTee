//
//  MTETShirtViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RestKit.h"

@class MTETShirt;

@interface MTETShirtViewController : UIViewController <UISplitViewControllerDelegate, UIActionSheetDelegate, RKRequestDelegate>

@property (strong, nonatomic) MTETShirt *tshirt;

- (void)configureView;
- (IBAction)dismissViewController:(id)sender;

@end
