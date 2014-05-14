//
//  LeadViewController.m
//  IphoneUTouch
//
//  Created by v v on 12-7-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeadViewController.h"

@interface LeadViewController ()

@end

@implementation LeadViewController

@synthesize leadDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView * bgView=[[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_bg_introduction" ofType:@"jpg"inDirectory:@"Images"] ]]; 
    bgView.frame=CGRectMake(0,0,320, 480);
    [self.view addSubview:bgView];
    [bgView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//UITouch *touch =  [touches anyObject];
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    CGPoint targetPoint = [[touches anyObject] locationInView:self.view];
    
    if(targetPoint.y>=120 && targetPoint.y<=220
       && targetPoint.x>=30 && targetPoint.x<=290)
    {
        [self.leadDelegate Lead:NO];
    }
    if(targetPoint.y>=250 && targetPoint.y<=370
       && targetPoint.x>=30 && targetPoint.x<=290)
    {
        [self.leadDelegate Lead:YES];
    }
}


@end
