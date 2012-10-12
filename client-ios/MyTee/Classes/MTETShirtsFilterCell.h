//
//  MTETShirtsFilterCell.h
//  mytee
//
//  Created by Terenn on 9/17/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTESettingCell.h"

@interface MTETShirtsFilterCell : MTESettingCell

@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end
