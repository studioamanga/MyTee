//
//  MTETShirtCell.m
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Keres-Sy, Studio AMANgA. All rights reserved.
//

#import "MTETShirtCell.h"

@implementation MTETShirtCell

- (void)layoutSubviews
{  
    [super layoutSubviews];     
    
    UIImage * lightTexture = [UIImage imageNamed:@"linen-light-bar"];
    UIColor * lightColor = [UIColor colorWithPatternImage:lightTexture];
    [self setBackgroundColor:lightColor];
}

@end
