//
//  MTETShirtCell.m
//  mytee
//
//  Created by Vincent Tourraine on 2/2/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTETShirtCell.h"

@implementation MTETShirtCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIImage * lightTexture = [UIImage imageNamed:@"linen-light-bar"];
        UIColor * lightColor = [UIColor colorWithPatternImage:lightTexture];
        [self.contentView setBackgroundColor:lightColor];
        [self.textLabel setBackgroundColor:lightColor];
    }
    
    return self;
}

@end
