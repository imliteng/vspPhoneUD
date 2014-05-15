//
//  SingersSelViewController.m
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingersSelViewController.h"
#import "PopoverController.h"

@interface SingersSelViewController ()

@end

@implementation SingersSelViewController

@synthesize  singersInfoContrl;

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

    self.navigationItem.title=@"歌星点歌";
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    UIImage *ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CNMen" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CNWomen" ofType:@"png"inDirectory:@"Images/"]]; 
    UIImage *ButtonImage2 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CNGroup" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage3 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EA" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage4 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JP" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage5 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"KR" ofType:@"png"inDirectory:@"Images/"]];
    
    NSArray *imageArray = [NSArray arrayWithObjects:ButtonImage,ButtonImage1,ButtonImage2,ButtonImage3,ButtonImage4,ButtonImage5,nil];
    for(int i=0;i<6;i++)
    {
        CGRect buttonsPos=CGRectMake(13+(i%3)*(84+20),20+(134.5f+20)*(i/3),84,134.5f);
        UIButton* toolButtons=[[UIButton alloc]init ];
        toolButtons.tag=i+1;
        [toolButtons setFrame:buttonsPos];
         [toolButtons setBackgroundImage:(UIImage*)[imageArray objectAtIndex:i ] forState:UIControlStateNormal];
        [toolButtons addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside]; 
        [self.view addSubview:toolButtons];
        [toolButtons release];
    }    
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    MySingerTypeIndex=0;
}

-(void) dealloc
{
    [singersInfoContrl release];
    [pre release];
    
    [super dealloc];
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

-(void) buttonPressed:(UIButton*) button
{
    int tag=button.tag;
    
    MySingerTypeIndex=tag;
    
    SingersInfoViewController * singersInfoTmp=[[SingersInfoViewController alloc]initWithNibNameAndType:@"SingersInfoViewController" bundle:nil Type:tag];
    self.singersInfoContrl=singersInfoTmp;
    [singersInfoTmp release];
    [self.singersInfoContrl viewDidAppear:YES];
    // self.singersInfoContrl.singersType=tag;
    [self.navigationController pushViewController:self.singersInfoContrl animated:YES];
}

-(void) RefreshData
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    if(MySingerTypeIndex>0)
    {
       // [self.singersInfoContrl RefreshData];
    }
}

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid
{
    if(MySingerTypeIndex!=0)
    {
        [self.singersInfoContrl ChangeSongsStat:songId Type:type Pid:pid];
    }
}



@end
