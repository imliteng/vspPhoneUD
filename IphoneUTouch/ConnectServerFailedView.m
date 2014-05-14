//
//  ConnectServerFailedView.m
//  VisionTouch
//
//  Created by v v on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConnectServerFailedView.h"

@implementation ConnectServerFailedView
@synthesize MyDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor clearColor];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"连接服务器失败，请确认服务器IP及端口后重试" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"进入演示", nil];
    [alert show];
    [alert release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	//return YES;
    return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            //if([[UIApplication sharedApplication] respondsToSelector:@selector(terminateWithSuccess)])
             //   [[UIApplication sharedApplication] performSelector:@selector(terminateWithSuccess)];
            exit(1);
            break;
        case 1:
            [self.MyDelegate didDemoLink];
            break;
        default:
            break;
    }
}


@end
