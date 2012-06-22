//
//  MTESettingCell.m
//  mytee
//
//  Created by Vincent Tourraine on 2/20/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTESettingCell.h"

@implementation MTESettingCell

- (void)layoutSubviews
{  
    [super layoutSubviews];     
    
    UIImage * lightTexture = [UIImage imageNamed:@"linen-light-cell"];
    UIColor * lightColor = [UIColor colorWithPatternImage:lightTexture];
    [self setBackgroundColor:lightColor];
}

@end
