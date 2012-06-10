//
//  MTEStoreViewController.h
//  mytee
//
//  Created by Vincent Tourraine on 2/5/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

@class MTEStore;

@interface MTEStoreViewController : UIViewController

@property (strong, nonatomic) MTEStore * store;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addressIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
