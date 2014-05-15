//
//  LangugeViewController.m
//  IphoneUTouch
//
//  Created by v v on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LangugeViewController.h"

@interface LangugeViewController ()

@end

@implementation LangugeViewController

@synthesize songInfoByLangugeContrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    MylanguageIndex=0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"语种点歌";

    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    UIImage *ButtonImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CN" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage1 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HK" ofType:@"png"inDirectory:@"Images/"]]; 
    UIImage *ButtonImage2 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TW" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage3 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EN" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage4 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JPS" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage5 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"KRS" ofType:@"png"inDirectory:@"Images/"]];
    UIImage *ButtonImage6 =  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Other" ofType:@"png"inDirectory:@"Images/"]];
    
    NSArray *imageArray = [NSArray arrayWithObjects:ButtonImage,ButtonImage1,ButtonImage2,ButtonImage3,ButtonImage4,ButtonImage5,nil];
    for(int i=0;i<6;i++)
    {
        CGRect buttonsPos=CGRectMake(25+(i%3)*(74+25),40+(88.5f+20)*(i/3),78.5,85.5f);
        UIButton* toolButtons=[[UIButton alloc]init ];
        toolButtons.tag=i+1;
        [toolButtons setFrame:buttonsPos];
        [toolButtons setBackgroundImage:(UIImage*)[imageArray objectAtIndex:i ] forState:UIControlStateNormal];
        [toolButtons addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside]; 
        [self.view addSubview:toolButtons];
        [toolButtons release];
    }    
    
    CGRect buttonsPos=CGRectMake(25+(7%3)*(74+25),40+(88.5f+20)*(7/3),78.5,85.5f);
    UIButton* toolButtons=[[UIButton alloc]init ];
    toolButtons.tag=7;
    [toolButtons setFrame:buttonsPos];
    [toolButtons setBackgroundImage:ButtonImage6 forState:UIControlStateNormal];
    [toolButtons addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside]; 
    [self.view addSubview:toolButtons];
    [toolButtons release];
}

-(void) dealloc
{
    [songInfoByLangugeContrl release];
    
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

-(void)buttonPressed:(UIButton *) button
{
    int tag=button.tag;
    
    NSString * szname=nil;
    if(tag==1)
    {
        szname=[[NSString alloc]initWithString:@"国语歌曲"];
    }
    else if (tag==2)
    {
        szname=[[NSString alloc]initWithString:@"粤语歌曲"];
    }
    else if (tag==3)
    {
        szname=[[NSString alloc]initWithString:@"闽南语歌曲"];
    }
    else if (tag==4)
    {
        szname=[[NSString alloc]initWithString:@"英语歌曲"];
    }
    else if (tag==5)
    {
        szname=[[NSString alloc]initWithString:@"日语歌曲"];
    }
    else if (tag==6)
    {
        szname=[[NSString alloc]initWithString:@"韩语歌曲"];
    }
    else if (tag==7)
    {
        szname=[[NSString alloc]initWithString:@"其他歌曲"];
    }
    
    SongInViewController * songInfoTmp=[[SongInViewController alloc]initWithNibAndType:@"SongInViewController" bundle:nil Type:tag Id:@"" Name:szname ];
    self.songInfoByLangugeContrl=songInfoTmp;
    [songInfoTmp release];
    [self.songInfoByLangugeContrl viewDidAppear:YES];
    [self.navigationController pushViewController:self.songInfoByLangugeContrl animated:YES];
    [szname release];
}

-(void)ChangeSongsStat:(NSString*)songId Type:(int)type Pid:(NSString*)pid
{
    if(MylanguageIndex!=0)
    {
        [self.songInfoByLangugeContrl ChangeSongsStat:songId Type:type Pid:pid];
    }
}

@end
