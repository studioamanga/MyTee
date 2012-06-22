//
//  MTEStoreOnlineViewController.m
//  mytee
//
//  Created by Vincent Tourraine on 6/11/12.
//  Copyright (c) 2012 Studio AMANgA. All rights reserved.
//

#import "MTEStoreOnlineViewController.h"

#import "MTEStore.h"
#import <QuartzCore/QuartzCore.h>

@interface MTEStoreOnlineViewController ()

@property (nonatomic, weak) IBOutlet UIWebView * webView;

@end

@implementation MTEStoreOnlineViewController

@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.layer.borderWidth = 1;
    self.webView.layer.cornerRadius = 4;
    
    if (self.store.url.length > 0)
    {
        NSURLRequest * URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.store.url]];
        [self.webView loadRequest:URLRequest];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.webView = nil;
}

#pragma mark - Actions

- (IBAction)presentActionSheet:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
}

#pragma mark - Action Sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        NSURL * URL = [NSURL URLWithString:self.store.url];
        [[UIApplication sharedApplication] openURL:URL];
    }
}
@end
