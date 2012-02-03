//
//  MTETShirtViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTETShirt;

@interface MTETShirtViewController : UIViewController

@property (strong, nonatomic) MTETShirt * tshirt;
@property (weak, nonatomic) IBOutlet UIImageView *tshirtImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@end
